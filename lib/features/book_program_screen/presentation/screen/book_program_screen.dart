import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/features/book_program_screen/data/models/get_program_by_id_response.dart';
import 'package:wavex/features/book_program_screen/logic/book_program_cubit.dart';
import 'package:wavex/features/classes_screen/data/models/get_programs_response.dart'
    as programs;
import 'package:wavex/main.dart';
import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/login_required_dialog.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/format_data_to_string.dart';
import '../../../sessions_screen/data/models/get_sessions_response.dart';
import '../../data/models/get_locations_response.dart';
import '../widgets/calendar_pager.dart';

class BookProgramScreen extends StatefulWidget {
  const BookProgramScreen({super.key, required this.id});

  final int id;

  @override
  State<BookProgramScreen> createState() => _BookProgramScreenState();
}

class _BookProgramScreenState extends State<BookProgramScreen> with RouteAware {
  final int _currentNavIndex = 1;
  DateTime selectedDate = DateTime.now();

  ProgramData programData = ProgramData();
  int locationId = 0;
  int? selectedProgramId;
  List<LocationData> locations = [];
  List<programs.ProgramData> programFilters = [];
  List<SessionData> sessions = [];
  int sessionsAnimationKey = 0;

  bool _isPaymentInProgress = false;
  bool isLoading = false;

  @override
  void initState() {
    BookProgramCubit.get(context).getProgramById(id: widget.id);
    BookProgramCubit.get(context).getLocations();
    BookProgramCubit.get(context).getPrograms();
    BookProgramCubit.get(context).getSessions(
      date: "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
      programId: selectedProgramId,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // ✅ ده هيتنادى لما ترجع للـ screen دي
    BookProgramCubit.get(context).getProgramById(id: widget.id);
    BookProgramCubit.get(context).getLocations();
    BookProgramCubit.get(context).getPrograms();
    BookProgramCubit.get(context).getSessions(
      date: "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
      programId: selectedProgramId,
      locationId: locationId == 0 ? null : locationId,
    );
  }

  Future<void> _processPayment(BuildContext context, int sessionId) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // ✅ success
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate("bookProgram_payment_success"),
            ),
          ),
        );

      navigatorKey.currentState!
          .pushNamed(RouteStrings.transactionSuccessScreen);
    } on StripeException catch (e) {
      // ✅ StripeException has error.message
      final errorMessage =
          e.error.localizedMessage ?? e.error.message ?? "Payment canceled";

      if (errorMessage.contains("canceled")) {
        navigatorKey.currentState!.pushNamed(
          RouteStrings.transactionFailedScreen,
          arguments: {"sessionId": sessionId, "label": "Canceled"},
        );
      } else {
        navigatorKey.currentState!.pushNamed(
          RouteStrings.transactionFailedScreen,
          arguments: {"sessionId": sessionId, "label": "Failed"},
        );
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(e.error.message ?? ""), // <-- show Stripe error
          ),
        );

      // navigatorKey.currentState!.pushNamed(
      //   RouteStrings.transactionFailedScreen,
      //   arguments: {"sessionId": sessionId, "label": "Canceled"},
      // );
    } catch (e) {
      // ✅ fallback for unexpected errors
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              e.toString(), // <-- show raw error (can replace with nicer handling)
            ),
          ),
        );

      navigatorKey.currentState!.pushNamed(
        RouteStrings.transactionFailedScreen,
        arguments: {"sessionId": sessionId, "label": "Payment canceled"},
      );
    }
  }

  Future<void> makePayment(
      String? paymentIntentClientSecret, int sessionId) async {
    try {
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: CacheHelper.getdata(key: "userName") ?? "Guest",
        ),
      );
      await _processPayment(context, sessionId);
    } catch (_) {}
  }

  int? loadingSessionId;

  Future<void> _handleBook(SessionData session) async {
    final locationRequiresForm = session.location?.requiresFormSubmission ??
        session.requiresFormSubmission == true;
    final submissionStatus =
        session.location?.formSubmissionStatus ?? session.formSubmissionStatus;
    if (locationRequiresForm && submissionStatus != 'approved') {
      if (submissionStatus == 'pending') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Your branch request is still awaiting approval.'),
        ));
        return;
      }
      final submitted = await navigatorKey.currentState!.pushNamed(
        RouteStrings.locationFormScreen,
        arguments: {
          'locationId': session.locationId ?? session.location?.id ?? 0,
          'sessionId': session.id,
        },
      );
      if (submitted == true && mounted) {
        BookProgramCubit.get(context).getSessions(
          date:
              "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
          programId: selectedProgramId,
          locationId: locationId == 0 ? null : locationId,
        );
      }
      return;
    }

    setState(() => loadingSessionId = session.id);
    if (session.isFree == true) {
      BookProgramCubit.get(context).bookFreeSession(sessionId: session.id ?? 0);
    } else {
      BookProgramCubit.get(context).payment(sessionId: session.id ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderWidget(isWithBack: true),
          BlocListener<BookProgramCubit, BookProgramState>(
            listener: (context, state) async {
              if (state is PaymentSuccessState) {
                setState(() => loadingSessionId = null);
                if (_isPaymentInProgress) return;
                _isPaymentInProgress = true;
                await makePayment(
                  state.paymentResponse.clientSecret,
                  state.sessionId,
                );
                _isPaymentInProgress = false;
                setState(() => isLoading = false);
              }
              if (state is BookFreeSessionSuccessState) {
                setState(() => loadingSessionId = null);
                navigatorKey.currentState!
                    .pushNamed(RouteStrings.sessionsScreen);

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content:
                          Text(state.bookFreeSessionResponse.message ?? ""),
                      backgroundColor: Colors.teal,
                    ),
                  );
                setState(() => isLoading = false);
              }
              if (state is PaymentErrorState) {
                setState(() => loadingSessionId = null);
                setState(() => isLoading = false);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
              }
              if (state is BookFreeSessionErrorState) {
                setState(() => loadingSessionId = null);
                setState(() => isLoading = false);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
              }
              if (state is PaymentLoadingState) {
                setState(() => isLoading = true);
              }
            },
            child: const SizedBox.shrink(),
          ),
          Expanded(
            child: BlocConsumer<BookProgramCubit, BookProgramState>(
              listener: (context, state) {
                if (state is GetProgramByIdSuccessState) {
                  setState(() => programData =
                      state.programByIdResponse.data ?? ProgramData());
                }
                if (state is GetLocationsSuccessState) {
                  setState(() {
                    locations = [
                      LocationData(areaName: "All", id: 0),
                      ...?state.locationsResponse.data,
                    ];
                    locationId = 0;
                  });
                }
                if (state is GetProgramsSuccessState) {
                  setState(() {
                    programFilters = state.programsResponse.data ?? [];
                  });
                }
                if (state is GetSessionsSuccessState) {
                  setState(() {
                    sessions = state.sessionsResponse.data ?? [];
                    sessionsAnimationKey++;
                  });
                }
              },
              builder: (context, state) {
                if (programData.id != null) {
                  return _buildClassDetailScreen();
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
          BottomNavigation(currentIndex: _currentNavIndex),
        ],
      ),
    );
  }

  Widget _buildClassDetailScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildClassHeader(),
          _buildClassImage(),
          _buildLocationTabs(),
          _buildCalendar(),
          _buildAvailabilityHeader(),
          _buildProgramTabs(),
          _buildSessionsBookings(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildClassHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop, color: Color(0xFF45818B), size: 24),
              const SizedBox(width: 8),
              Text(
                programData.name ?? "",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF45818B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            programData.description ?? "",
            style:
                const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildClassImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(programData.coverImage ?? ""),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLocationTabs() {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(16.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() => locationId = locations[index].id ?? 0);
              BookProgramCubit.get(context).getSessions(
                date:
                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                programId: selectedProgramId,
                locationId: locationId == 0 ? null : locationId,
              );
            },
            child: _buildLocationTab(
              locations[index].areaName ?? "",
              locationId == locations[index].id,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF45818B) : const Color(0xffE2F2F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  setDate(DateTime selectedDate) {
    setState(() => this.selectedDate = selectedDate);
    BookProgramCubit.get(context).getSessions(
      date: "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
      programId: selectedProgramId,
      locationId: locationId == 0 ? null : locationId,
    );
  }

  Widget _buildCalendar() => CalendarPager(onTap: setDate);

  Widget _buildAvailabilityHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: const Color(0x4DFCE566),
      child: Text(
        "Available Locations on date ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} for :",
        style: GoogleFonts.poppins().copyWith(
          color: const Color(0xFF2F545F),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<programs.ProgramData> get _programTabs {
    final currentProgram = programs.ProgramData(
      id: programData.id,
      name: programData.name,
      subtitle: programData.subtitle,
      description: programData.description,
      mainImage: programData.mainImage,
      coverImage: programData.coverImage,
      benefits: programData.benefits,
      isActive: programData.isActive,
    );

    final tabs = <programs.ProgramData>[];
    for (final program in [currentProgram, ...programFilters]) {
      if (program.id == null || tabs.any((item) => item.id == program.id)) {
        continue;
      }
      tabs.add(program);
    }
    return tabs;
  }

  Widget _buildProgramTabs() {
    final tabs = _programTabs;

    return Container(
      height: 58,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final program = isAll ? null : tabs[index - 1];
          final isSelected = isAll
              ? selectedProgramId == null
              : selectedProgramId == program?.id;

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              setState(() => selectedProgramId = program?.id);
              BookProgramCubit.get(context).getSessions(
                date:
                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                programId: selectedProgramId,
                locationId: locationId == 0 ? null : locationId,
              );
            },
            child: _buildProgramTab(
              isAll ? "All Programs" : program?.name ?? "",
              isSelected,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgramTab(String text, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minWidth: 128),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4B899E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF45818B)
                .withValues(alpha: isSelected ? 0.55 : 0.35),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.bellotaText().copyWith(
            color: isSelected ? Colors.white : const Color(0xFF4B899E),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String formatTime(String time) {
    final parts = time.split(":");
    if (parts.length >= 2) {
      return "${parts[0]}:${parts[1]}";
    }
    return time;
  }

  Widget _buildSessionsBookings() {
    return BlocBuilder<BookProgramCubit, BookProgramState>(
      builder: (context, state) {
        final isUpdating = state is GetSessionsLoadingState;

        if (isUpdating && sessions.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 520),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: _buildSessionsContent(
            key: ValueKey(sessionsAnimationKey),
            isUpdating: isUpdating,
          ),
        );
      },
    );
  }

  Widget _buildSessionsContent({
    required Key key,
    required bool isUpdating,
  }) {
    return Stack(
      key: key,
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 360),
          opacity: isUpdating ? 0.55 : 1,
          child: _buildSessionsList(),
        ),
        if (isUpdating)
          const Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: LinearProgressIndicator(
                minHeight: 3,
                backgroundColor: Colors.transparent,
                color: Color(0xFF4B899E),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSessionsList() {
    if (sessions.isNotEmpty) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sessions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final loc = sessions[index];
          return _buildLocationCard(loc, index + 1);
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/not_found.png"),
            const SizedBox(
              height: 5,
            ),
            Text(
              "No sessions found Within this day",
              style: GoogleFonts.inter().copyWith(
                color: const Color(0xFF8DADAF),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildLocationCard(SessionData session, int index) {
    final remainingSeats =
        (session.maxCapacity ?? 0) - (session.currentBookings ?? 0);
    final isFullyBooked = remainingSeats == 0;
    final statusText = isFullyBooked
        ? AppLocalizations.of(context).translate("bookProgram_fully_booked")
        : session.isFree == true
            ? "Available Now"
            : "Scheduled";
    final statusColor = isFullyBooked
        ? Colors.red
        : session.isFree == true
            ? const Color(0xFF44858F)
            : const Color(0xFFF37E10);
    final locationText = [
      session.location?.areaName,
      session.location?.venueName,
    ].where((item) => item != null && item.isNotEmpty).join(" - ");

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(
            color: isFullyBooked
                ? Colors.red
                : session.isFree == true
                    ? const Color(0xFF44858F)
                    : const Color(0xFF45818B),
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/water_drop_icon.png",
            color: isFullyBooked
                ? Colors.red
                : session.isFree == true
                    ? const Color(0xFF44858F)
                    : const Color(0xFF45818B),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session.program?.name ?? programData.name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F545F),
                        ),
                      ),
                    ),
                    Text(
                      statusText,
                      style: GoogleFonts.poppins().copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatDate(context, session.sessionDate),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            color: Color(0xFF4DBDD5), size: 20),
                        const SizedBox(width: 5),
                        Text(
                          '${session.instructor?.firstName ?? ''} ${session.instructor?.lastName ?? ''}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isFullyBooked
                            ? AppLocalizations.of(context)
                                .translate("bookProgram_fully_booked")
                            : "$remainingSeats ${AppLocalizations.of(context).translate("bookProgram_seats_left")}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isFullyBooked
                              ? Colors.red
                              : const Color(0xFF45818B),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.watch_later,
                            color: Color(0xFF4DBDD5), size: 20),
                        Text(
                          "${formatTime(session.startTime ?? "")} - ${formatTime(session.endTime ?? "")}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isFullyBooked
                                ? Colors.red
                                : const Color(0xFF45818B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (locationText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    locationText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F545F),
                    ),
                  ),
                ],

                // Modified pricing section to handle free sessions
                if (session.isFree !=
                    true) // Only show pricing for paid sessions
                  session.discountPercentage != null
                      ? Column(
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${AppLocalizations.of(context).translate("bookProgram_capacity")}: ${session.maxCapacity ?? ""}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: (session.maxCapacity! -
                                                  session.currentBookings!) ==
                                              0
                                          ? Colors.red
                                          : const Color(0xFF45818B),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      session.price.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.red,
                                      ),
                                      child: Text(
                                        "${session.discountPercentage.toString()}% OFF",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),

                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (session.isFree !=
                        true) // Only show capacity for paid sessions when no discount
                      session.discountPercentage != null
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: Text(
                                "${AppLocalizations.of(context).translate("bookProgram_capacity")}: ${session.maxCapacity ?? ""}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: (session.maxCapacity! -
                                              session.currentBookings!) ==
                                          0
                                      ? Colors.red
                                      : const Color(0xFF45818B),
                                ),
                              ),
                            ),

                    // Show capacity for free sessions
                    if (session.isFree == true)
                      Expanded(
                        child: Text(
                          "${AppLocalizations.of(context).translate("bookProgram_capacity")}: ${session.maxCapacity ?? ""}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: (session.maxCapacity! -
                                        session.currentBookings!) ==
                                    0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ),

                    ElevatedButton(
                      onPressed: session.isBooked == null
                          ? (loadingSessionId != null)
                              ? null
                              : CacheHelper.getdata(key: "userToken") == null
                                  ? () => showLoginRequiredDialog(context)
                                  : (session.maxCapacity! -
                                              session.currentBookings!) ==
                                          0
                                      ? null
                                      : () => _handleBook(session)
                          : session.isBooked!
                              ? null
                              : isLoading
                                  ? null
                                  : CacheHelper.getdata(key: "userToken") ==
                                          null
                                      ? () => showLoginRequiredDialog(context)
                                      : (session.maxCapacity! -
                                                  session.currentBookings!) ==
                                              0
                                          ? null
                                          : () => _handleBook(session),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (session.maxCapacity! -
                                    session.currentBookings!) ==
                                0
                            ? const Color(0xff8AB5BC)
                            : session.isFree == true
                                ? Colors.green // Green button for free sessions
                                : AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: (loadingSessionId == session.id)
                          ? const Center(child: CircularProgressIndicator())
                          : Text(
                              // Modified button text for free sessions
                              session.isFree == true
                                  ? "${AppLocalizations.of(context).translate("bookProgram_book_session")} - FREE"
                                  : "${AppLocalizations.of(context).translate("bookProgram_book_session")} ${CacheHelper.getdata(key: "selectedCurrency") == "GBP" ? "£" : CacheHelper.getdata(key: "selectedCurrency") == "USD" ? "\$" : CacheHelper.getdata(key: "selectedCurrency") == "EGP" ? "ج.م" : "£"}${session.discountedPrice ?? session.price ?? ""}",
                              style: GoogleFonts.inter().copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildLocationCard(SessionData session, int index) {
  //   // print(isLoading && session.isBooked!);
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFE2F2F5),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border(
  //         left: BorderSide(
  //           color: session.maxCapacity == session.currentBookings
  //               ? Colors.red
  //               : const Color(0xFF45818B),
  //           width: 4,
  //         ),
  //       ),
  //     ),
  //     child: Row(
  //       // crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Image.asset(
  //           "assets/images/water_drop_icon.png",
  //           color: session.maxCapacity == session.currentBookings
  //               ? Colors.red
  //               : const Color(0xFF45818B),
  //         ),
  //         const SizedBox(width: 5),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       // "${AppLocalizations.of(context).translate("bookProgram_location")} $index",
  //                       '${session.location?.areaName ?? ''} - ${session.location?.venueName ?? ''}',
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                         color: Color(0xFF45818B),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       formatDate(context, session.sessionDate),
  //                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //                     ),
  //                   ),
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.person,
  //                           color: Color(0xFF4DBDD5), size: 20),
  //                       const SizedBox(
  //                         width: 5,
  //                       ),
  //                       Text(
  //                         '${session.instructor?.firstName ?? ''} ${session.instructor?.lastName ?? ''}',
  //                         style:
  //                             TextStyle(fontSize: 12, color: Colors.grey[600]),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       (session.maxCapacity! - session.currentBookings!) == 0
  //                           ? AppLocalizations.of(context)
  //                               .translate("bookProgram_fully_booked")
  //                           : "${(session.maxCapacity! - session.currentBookings!)} ${AppLocalizations.of(context).translate("bookProgram_seats_left")}",
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                         color: (session.maxCapacity! -
  //                                     session.currentBookings!) ==
  //                                 0
  //                             ? Colors.red
  //                             : const Color(0xFF45818B),
  //                       ),
  //                     ),
  //                   ),
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.watch_later,
  //                           color: Color(0xFF4DBDD5), size: 20),
  //                       Text(
  //                         "${formatTime(session.startTime ?? "")} - ${formatTime(session.endTime ?? "")}",
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w500,
  //                           color: (session.maxCapacity! -
  //                                       session.currentBookings!) ==
  //                                   0
  //                               ? Colors.red
  //                               : const Color(0xFF45818B),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               session.discountPercentage != null
  //                   ? Column(
  //                       children: [
  //                         const SizedBox(height: 8),
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               child: Text(
  //                                 "${AppLocalizations.of(context).translate("bookProgram_capacity")}: ${session.maxCapacity ?? ""}",
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   fontWeight: FontWeight.w500,
  //                                   color: (session.maxCapacity! -
  //                                               session.currentBookings!) ==
  //                                           0
  //                                       ? Colors.red
  //                                       : const Color(0xFF45818B),
  //                                 ),
  //                               ),
  //                             ),
  //                             Row(
  //                               children: [
  //                                 Text(
  //                                   session.price.toString() ?? "",
  //                                   style: const TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.grey,
  //                                       decoration: TextDecoration.lineThrough),
  //                                 ),
  //                                 const SizedBox(
  //                                   width: 5,
  //                                 ),
  //                                 Container(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       horizontal: 5, vertical: 5),
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(5),
  //                                     color: Colors.red,
  //                                   ),
  //                                   child: Text(
  //                                     "${session.discountPercentage.toString() ?? ""}% OFF",
  //                                     style: const TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w500,
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     )
  //                   : const SizedBox.shrink(),
  //               const SizedBox(height: 8),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   session.discountPercentage != null
  //                       ? const SizedBox.shrink()
  //                       : Expanded(
  //                           child: Text(
  //                             "${AppLocalizations.of(context).translate("bookProgram_capacity")}: ${session.maxCapacity ?? ""}",
  //                             style: TextStyle(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w500,
  //                               color: (session.maxCapacity! -
  //                                           session.currentBookings!) ==
  //                                       0
  //                                   ? Colors.red
  //                                   : const Color(0xFF45818B),
  //                             ),
  //                           ),
  //                         ),
  //                   ElevatedButton(
  //                     onPressed: session.isBooked == null
  //                         ? (loadingSessionId != null)
  //                             ? null
  //                             : CacheHelper.getdata(key: "userToken") == null
  //                                 ? () => showLoginRequiredDialog(context)
  //                                 : (session.maxCapacity! -
  //                                             session.currentBookings!) ==
  //                                         0
  //                                     ? () {
  //                                         ScaffoldMessenger.of(context)
  //                                             .showSnackBar(
  //                                           SnackBar(
  //                                             content: Text(
  //                                               AppLocalizations.of(context)
  //                                                   .translate(
  //                                                       "bookProgram_fully_booked_message")
  //                                                   .replaceAll("{index}",
  //                                                       index.toString()),
  //                                             ),
  //                                             backgroundColor:
  //                                                 const Color(0xFF45818B),
  //                                           ),
  //                                         );
  //                                       }
  //                                     : () {
  //                                         setState(() => loadingSessionId = session
  //                                             .id); // start loading only for this session
  //                                         BookProgramCubit.get(context).payment(
  //                                           sessionId: session.id ?? 0,
  //                                         );
  //                                       }
  //                         : session.isBooked!
  //                             ? null
  //                             : isLoading
  //                                 ? null
  //                                 : CacheHelper.getdata(key: "userToken") ==
  //                                         null
  //                                     ? () => showLoginRequiredDialog(context)
  //                                     : (session.maxCapacity! -
  //                                                 session.currentBookings!) ==
  //                                             0
  //                                         ? () {
  //                                             ScaffoldMessenger.of(context)
  //                                                 .showSnackBar(
  //                                               SnackBar(
  //                                                 content: Text(
  //                                                   AppLocalizations.of(context)
  //                                                       .translate(
  //                                                           "bookProgram_fully_booked_message")
  //                                                       .replaceAll("{index}",
  //                                                           index.toString()),
  //                                                 ),
  //                                                 backgroundColor:
  //                                                     const Color(0xFF45818B),
  //                                               ),
  //                                             );
  //                                           }
  //                                         : () {
  //                                             setState(() => loadingSessionId =
  //                                                 session
  //                                                     .id); // start loading only for this session
  //
  //                                             BookProgramCubit.get(context)
  //                                                 .payment(
  //                                               sessionId: session.id ?? 0,
  //                                             );
  //                                           },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor:
  //                           (session.maxCapacity! - session.currentBookings!) ==
  //                                   0
  //                               ? const Color(0xff8AB5BC)
  //                               : AppColors.primaryColor,
  //                       foregroundColor: Colors.white,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20)),
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 16, vertical: 8),
  //                     ),
  //                     child: (loadingSessionId == session.id)
  //                         ? const Center(child: CircularProgressIndicator())
  //                         : Text(
  //                             "${AppLocalizations.of(context).translate("bookProgram_book_session")} ${CacheHelper.getdata(key: "selectedCurrency") == "GBP" ? "£" : CacheHelper.getdata(key: "selectedCurrency") == "USD" ? "\$" : CacheHelper.getdata(key: "selectedCurrency") == "EGP" ? "ج.م" : "£"}${session.discountedPrice ?? session.price ?? ""}",
  //                             style: GoogleFonts.inter().copyWith(
  //                               color: Colors.white,
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoginRequiredDialog(),
    );
  }
}
