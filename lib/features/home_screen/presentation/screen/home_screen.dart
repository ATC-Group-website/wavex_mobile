import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wavex/core/app_localization.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/features/home_screen/data/models/get_instructors_response.dart';
import 'package:wavex/features/home_screen/data/models/notifications_response.dart';
import 'package:wavex/features/home_screen/logic/home_cubit.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/login_required_dialog.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../core/theme/colors.dart';
import '../../../../main.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../classes_screen/data/models/get_programs_response.dart';
import '../../../instructors_screen/presentation/instructors_screen.dart';

class CoachDialog extends StatelessWidget {
  final int coachId;
  final String coachName;
  final String coachImage;
  final String className;
  final VoidCallback? onSchedulePressed;

  const CoachDialog({
    super.key,
    required this.coachName,
    required this.coachId,
    required this.coachImage,
    required this.className,
    this.onSchedulePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      // Make the dialog background transparent
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      // Adjust padding
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          // Light grey background for the card
          borderRadius: BorderRadius.circular(25),
          // Rounded corners for the card
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 10), // Subtle shadow for depth
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Make the column take minimum space
          children: [
            // Profile Image

            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // Rounded corners for the image container
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 5), // Shadow for the image
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // Clip image to rounded corners
                    child: Image.network(
                      coachImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300], // Placeholder color on error
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Spacing below image

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Coach Name
                      Text(
                        coachName,
                        style: GoogleFonts.inter().copyWith(
                          color: const Color(0xFF45818B),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5), // Spacing below name

                      // Coach Title
                      Text(
                        'Instructor',
                        style: GoogleFonts.inter().copyWith(
                          color: const Color(0xFFF30F0F),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25), // Spacing below title
            //
            // // Class Information
            // Text(
            //   'Class : $className',
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            //   style: GoogleFonts.inter().copyWith(
            //     color: const Color(0xFF45818B),
            //     fontSize: 20,
            //     fontWeight: FontWeight.w600,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            //
            // const SizedBox(height: 30), // Spacing before button

            // Schedule Button
            SizedBox(
              width: double.infinity, // Button takes full width
              height: 50, // Fixed height for the button
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  navigatorKey.currentState!.pushNamed(RouteStrings.instructorsScreen,arguments: {
                    "instructorId" : coachId,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  // Teal background for button
                  foregroundColor: Colors.white,
                  // White text color
                  elevation: 0,
                  // No shadow for the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Rounded button corners
                  ),
                ),
                child: Text(
                  'Know More',
                  style: GoogleFonts.inter().copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Static method to easily show the dialog
  static Future<void> show(
    BuildContext context, {
    required String coachName,
    required int coachId,
    required String coachImage,
    required String className,
    VoidCallback? onSchedulePressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing by tapping outside
      builder: (BuildContext context) {
        return CoachDialog(
          coachName: coachName,coachId:coachId ,
          coachImage: coachImage,
          className: className,
          onSchedulePressed: onSchedulePressed,
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _carouselIndex = 0;
  int _coachIndex = 0;

  final PageController _workoutPageController =
      PageController(viewportFraction: 0.8);
  final PageController _coachPageController = PageController();

  bool isLoadingInstructors = true;
  bool _showLogoutDialog = false;

  List<InstructorData> instructors = [];
  List<ProgramData> programs = [];

  @override
  void initState() {
    HomeCubit.get(context).getInstructors();
    HomeCubit.get(context).getPrograms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final bool isMobile =
            sizingInformation.deviceScreenType == DeviceScreenType.mobile;
        final bool isTablet =
            sizingInformation.deviceScreenType == DeviceScreenType.tablet;
        final bool isDesktop =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop;

        // scale fonts based on device
        double titleSize = isMobile
            ? 20
            : isTablet
                ? 26
                : 32;
        double subtitleSize = isMobile
            ? 14
            : isTablet
                ? 18
                : 22;
        double cardHeight = isMobile
            ? 220
            : isTablet
                ? 280
                : 340;

        return Scaffold(
          body: Column(
            children: [
              HeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // 🔹 Welcome section
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 32),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: isMobile ? 30 : 40,
                              backgroundImage: NetworkImage(
                                CacheHelper.getdata(key: "userImage") ??
                                    "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=",
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate("home_welcomeBack"),
                                    style: GoogleFonts.poppins().copyWith(
                                      color: AppColors.primaryColor,
                                      fontSize: subtitleSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                      CacheHelper.getdata(key: "userName") ??
                                          AppLocalizations.of(context)
                                              .translate("home_guest"),
                                      style: GoogleFonts.poppins().copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: subtitleSize,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: CacheHelper.getdata(key: "userToken") ==
                                      null
                                  ? () => showLoginRequiredDialog(context)
                                  : () {
                                      HomeCubit.get(context)
                                          .getNotification(pageNumber: 1);

                                      HomeCubit cubit = HomeCubit.get(context);
                                      cubit.getNotification(pageNumber: 1);

                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (_) {
                                          return BlocProvider.value(
                                            value: cubit,
                                            // ✅ نفس instance بتاعة HomeCubit
                                            child: BlocBuilder<HomeCubit,
                                                HomeState>(
                                              builder: (context, state) {
                                                if (state
                                                        is GetNotificationLoadingState &&
                                                    cubit.allNotifications
                                                        .isEmpty) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }

                                                if (state
                                                    is MarkNotificationAsReadSuccessState) {
                                                  HomeCubit.get(context)
                                                      .getNotification(
                                                    pageNumber:
                                                        cubit.currentPage,
                                                  );
                                                }

                                                if (state
                                                    is GetNotificationErrorState) {
                                                  Navigator.pop(context);
                                                  return Center(
                                                    child: Text(
                                                        "Error: ${state.error}"),
                                                  );
                                                }

                                                return _buildNotificationsModal(
                                                  context,
                                                  cubit.allNotifications,
                                                  cubit.currentPage <
                                                      cubit.lastPage,
                                                  () => cubit.getNotification(
                                                      pageNumber:
                                                          cubit.currentPage +
                                                              1),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );

                                      // _showNotifications();
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: AppColors.primaryColor),
                                ),
                                child: SvgPicture.asset(
                                    "assets/svg_pictures/Bell.svg",
                                    width: isMobile ? 20 : 28),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🔹 Hero Banner
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 40),
                        child: Container(
                          height: isMobile
                              ? 160
                              : isTablet
                                  ? 220
                                  : 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image: AssetImage('assets/demo/6.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey.withOpacity(0.3),
                                  Colors.black.withOpacity(0.4),
                                ],
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("home_heroBanner"),
                                  style: GoogleFonts.inter().copyWith(
                                    color: Colors.white,
                                    fontSize: isMobile
                                        ? 18
                                        : isTablet
                                            ? 22
                                            : 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🔹 Programs Carousel
                      BlocConsumer<HomeCubit, HomeState>(
                        listener: (context, state) {
                          if (state is GetProgramsSuccessState) {
                            setState(() {
                              programs = state.programsResponse.data ?? [];
                            });
                          }
                          // if (state is GetNotificationSuccessState) {
                          //   // final notifications =
                          //   //     state.notificationsResponse.data?.data ?? [];
                          //   BuildContext parentContext = context;
                          //   showModalBottomSheet(
                          //     context: context,
                          //     backgroundColor: Colors.transparent,
                          //     isScrollControlled: true,
                          //     builder: (context) => _buildNotificationsModal(
                          //       context,
                          //       state.notificationsResponse,
                          //       state.hasMore,
                          //       () => HomeCubit.get(parentContext)
                          //           .getNotification(
                          //         pageNumber:
                          //             HomeCubit.get(parentContext).currentPage +
                          //                 1,
                          //       ),
                          //     ),
                          //   );
                          // }
                        },
                        builder: (context, state) {
                          if (programs.isNotEmpty) {
                            final currentProgram = programs[_carouselIndex];
                            return Column(
                              children: [
                                SizedBox(
                                  height: cardHeight,
                                  child: PageView.builder(
                                    controller: _workoutPageController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _carouselIndex = index;
                                      });
                                    },
                                    itemCount: programs.length,
                                    itemBuilder: (context, index) {
                                      return _buildWorkoutCard(programs[index],
                                          index == _carouselIndex, cardHeight);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 🔹 Carousel Indicators
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    programs.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _carouselIndex == index
                                            ? AppColors.primaryColor
                                            : const Color(0x846DAEB8),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // 🔹 Program Benefits
                                if (currentProgram.benefits != null &&
                                    currentProgram.benefits!.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 16 : 40),
                                    child: Column(
                                      children: currentProgram.benefits!
                                          .map((benefit) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12.0),
                                                child: _buildInfoCard(benefit),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),

                      const SizedBox(height: 32),

                      // 🔹 Coaches Section
                      Center(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("home_knowCoaches"),
                          style: GoogleFonts.inter().copyWith(
                            color: const Color(0xFF2E535F),
                            fontSize: titleSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      BlocConsumer<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (instructors.isNotEmpty) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: isMobile ? 140 : 200,
                                  child: PageView.builder(
                                    controller: _coachPageController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _coachIndex = index;
                                      });
                                    },
                                    itemCount: getCoachPageCount(instructors),
                                    itemBuilder: (context, index) {
                                      return _buildCoachesPage(index, isMobile);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // 🔹 Coach indicators
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    getCoachPageCount(instructors),
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _coachIndex == index
                                            ? AppColors.primaryColor
                                            : const Color(0x846DAEB8),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                        listener: (context, state) {
                          if (state is GetInstructorsLoadingState) {
                            setState(() {
                              isLoadingInstructors = true;
                            });
                          }
                          if (state is GetInstructorsSuccessState) {
                            setState(() {
                              instructors =
                                  state.instructorsResponse.data ?? [];
                              isLoadingInstructors = false;
                            });
                          }
                          if (state is GetInstructorsErrorState) {
                            setState(() {
                              isLoadingInstructors = false;
                            });
                          }
                        },
                      ),

                      // 🔹 Choose Class Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 40),
                        child: SizedBox(
                          width: double.infinity,
                          height: isMobile ? 56 : 64,
                          child: ElevatedButton(
                            onPressed: () {
                              navigatorKey.currentState!
                                  .pushNamed(RouteStrings.classesScreen);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("home_chooseClass"),
                                  style: GoogleFonts.inter().copyWith(
                                    color: Colors.white,
                                    fontSize: isMobile ? 18 : 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // 🔹 Bottom Decorations + Navigation
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0),
                painter: BottomWavePainter(),
              ),
              BottomNavigation(currentIndex: _currentIndex),
            ],
          ),
        );
      },
    );
  }

  // Reuse your helper widgets but adapt sizes
  Widget _buildWorkoutCard(
      ProgramData card, bool isFocused, double cardHeight) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              height: cardHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(card.mainImage ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: cardHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            if (isFocused)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.black45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.name ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          navigatorKey.currentState!.pushNamed(
                            RouteStrings.bookProgramScreen,
                            arguments: {"id": card.id ?? 0},
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B5F66),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("home_bookNow"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachesPage(int pageIndex, bool isMobile) {
    const perPage = 3;
    final startIndex = pageIndex * perPage;
    final endIndex = (startIndex + perPage).clamp(0, instructors.length);
    final pageInstructors = instructors.sublist(startIndex, endIndex);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: pageInstructors.map((coach) {
        return _buildCoachCard(coach, isMobile);
      }).toList(),
    );
  }

  int getCoachPageCount(List instructors, {int perPage = 3}) {
    if (instructors.isEmpty) return 0;
    return (instructors.length / perPage).ceil();
  }

  Widget _buildCoachCard(InstructorData coach, bool isMobile) {
    return InkWell(
      onTap: () {
        CoachDialog.show(
          context,
          coachName: "${coach.firstName ?? ""} ${coach.lastName ?? ""}",
          coachImage: coach.image ?? "",
          coachId: coach.id??0,
          className: coach.specializations!.isNotEmpty
              ? coach.specializations?.first ?? ""
              : "",
        );
      },
      child: Column(
        children: [
          Container(
            width: isMobile ? 80 : 120,
            height: isMobile ? 80 : 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(coach.image ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(coach.firstName ?? "",
              style: GoogleFonts.inter().copyWith(
                color: const Color(0xFF45818B),
                fontSize: isMobile ? 16 : 20,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE2F2F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE9F6FE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/water_drop_icon.png", width: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: GoogleFonts.inter().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xD823707C),
                )),
          ),
        ],
      ),
    );
  }

  void _showNotifications(
    BuildContext context,
    List<NotificationData> notifications,
    bool hasMore,
    void Function() loadMore,
  ) {
    setState(() {
      _showLogoutDialog = true;
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _buildNotificationsModal(context, notifications, hasMore, loadMore),
    );
  }

  void showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoginRequiredDialog();
      },
    );
  }

  Widget _buildNotificationsModal(
    BuildContext context,
    List<NotificationData> notifications,
    bool hasMore,
    void Function() loadMore,
  ) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (hasMore) {
          loadMore();
        }
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/svg_pictures/Bell.svg"),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).translate("home_notifications"),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount:
                  hasMore ? notifications.length + 1 : notifications.length,
              itemBuilder: (context, index) {
                if (index == notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final n = notifications[index];
                return ListTile(
                  onTap: () {
                    HomeCubit.get(context)
                        .markNotificationAsRead(notificationId: n.id ?? 0);
                  },
                  leading: Icon(Icons.notifications,
                      color: n.readAt != null ? Colors.grey : Colors.blue),
                  title: Text(
                    n.title ?? "",
                    style: GoogleFonts.inter().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: n.readAt != null ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    n.description ?? "",
                    style: GoogleFonts.inter().copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: n.readAt != null
                          ? Colors.grey
                          : const Color(0xFF45818B),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _workoutPageController.dispose();
    _coachPageController.dispose();
    super.dispose();
  }
}
