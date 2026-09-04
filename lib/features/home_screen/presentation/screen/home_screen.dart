import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/bottom_navigation_bar.dart';
import 'package:wavex/core/components/login_required_dialog.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/features/classes_screen/data/models/get_programs_response.dart';
import 'package:wavex/features/home_screen/data/models/get_instructors_response.dart';
import 'package:wavex/features/home_screen/logic/home_cubit.dart';
import 'package:wavex/features/liability_acknowledgement/presentation/widgets/waiver_consent_dialog.dart';
import 'package:wavex/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProgramData> _programs = const [];
  List<InstructorData> _instructors = const [];

  @override
  void initState() {
    super.initState();
    HomeCubit.get(context).getPrograms();
    HomeCubit.get(context).getInstructors();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) WaiverConsentDialog.showIfRequired(context);
    });
  }

  void _openPrograms() => navigatorKey.currentState!
      .pushNamedAndRemoveUntil(RouteStrings.classesScreen, (route) => false);

  void _openBookings() {
    if (CacheHelper.getdata(key: 'userToken') == null) {
      showDialog(context: context, builder: (_) => const LoginRequiredDialog());
    } else {
      navigatorKey.currentState!.pushNamed(RouteStrings.sessionsScreen);
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is GetProgramsSuccessState) {
            setState(() => _programs = state.programsResponse.data ?? const []);
          }
          if (state is GetInstructorsSuccessState) {
            setState(() =>
                _instructors = state.instructorsResponse.data ?? const []);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF7FAFB),
          body: SafeArea(
              child: Column(children: [
            _HomeHeader(
                onProfile: () => navigatorKey.currentState!
                    .pushNamed(RouteStrings.profileScreen)),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(children: [
                      _Hero(
                          program: _programs.isEmpty ? null : _programs.first,
                          onPressed: _openPrograms),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(
                            child: _QuickAction(
                                icon: Icons.event_available_outlined,
                                label: 'Programs',
                                onTap: _openPrograms)),
                        Container(
                            width: 1,
                            height: 30,
                            color: const Color(0xFFD6E5E9)),
                        Expanded(
                            child: _QuickAction(
                                icon: Icons.calendar_month_outlined,
                                label: 'My Booking',
                                onTap: _openBookings)),
                      ]),
                      const SizedBox(height: 22),
                      _SectionTitle(
                          title: 'Featured Programs',
                          action: 'See All',
                          onAction: _openPrograms),
                      if (_programs.isEmpty)
                        const Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator())
                      else
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _programs.take(4).length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.32,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (_, index) => _FeaturedCard(
                                  program: _programs[index],
                                  onTap: _openPrograms),
                            )),
                      const SizedBox(height: 28),
                      const _SectionTitle(title: 'Meet Our Instructors'),
                      SizedBox(
                          height: 106,
                          child: _instructors.isEmpty
                              ? const Center(
                                  child: Text(
                                      'Instructors will be announced soon.'))
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  itemCount: _instructors.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 16),
                                  itemBuilder: (_, index) =>
                                      _InstructorAvatar(_instructors[index]))),
                      const SizedBox(height: 18),
                      const _LocationPreview(),
                      const SizedBox(height: 12),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                  onPressed: _openPrograms,
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('Choose your Class'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24))))))
                    ]))),
            const BottomNavigation(currentIndex: 0),
          ])),
        ),
      );
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onProfile});
  final VoidCallback onProfile;
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 72,
      child: Stack(children: [
        Container(
            decoration: const BoxDecoration(
                color: Color(0xFFD6EDF3),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.elliptical(210, 24)))),
        Center(
            child: Image.asset('assets/images/wavx_home_logo.png', width: 122)),
        Positioned(
            right: 16,
            top: 17,
            child: IconButton(
                onPressed: onProfile,
                icon: const Icon(Icons.account_circle_outlined,
                    color: AppColors.primaryColor))),
      ]));
}

class _Hero extends StatelessWidget {
  const _Hero({this.program, required this.onPressed});
  final ProgramData? program;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final image = program?.mainImage;
    return Container(
        height: 158,
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.primaryColor,
            image: DecorationImage(
                image: image?.isNotEmpty == true
                    ? NetworkImage(image!)
                    : const AssetImage('assets/demo/2.jpg'),
                fit: BoxFit.cover)),
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xB5002730), Color(0x22002730)])),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('FLOW\nWITH IT',
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: .93)),
              const Spacer(),
              SizedBox(
                  width: 180,
                  height: 34,
                  child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4B96AC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text('Book A Session'))),
            ])));
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primaryColor)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: AppColors.primaryColor, fontSize: 12))
      ]));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Expanded(
            child: Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700))),
        if (action != null)
          TextButton(
              onPressed: onAction,
              child: Text(action!,
                  style: const TextStyle(
                      color: AppColors.primaryColor, fontSize: 12)))
      ]));
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.program, required this.onTap});
  final ProgramData program;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Color(0x180E667C), blurRadius: 8)
              ]),
          child: Column(children: [
            Expanded(
                child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                    child: program.mainImage?.isNotEmpty == true
                        ? Image.network(program.mainImage!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const ColoredBox(color: Color(0xFFD6EDF3)))
                        : const ColoredBox(color: Color(0xFFD6EDF3)))),
            Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 7),
                child: Column(children: [
                  Text(program.name ?? 'WaveX Program',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 3),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFD8EEF2),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text('Book Now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)))
                ])),
          ])));
}

class _InstructorAvatar extends StatelessWidget {
  const _InstructorAvatar(this.instructor);
  final InstructorData instructor;
  @override
  Widget build(BuildContext context) {
    final name =
        '${instructor.firstName ?? ''} ${instructor.lastName ?? ''}'.trim();
    return Column(children: [
      CircleAvatar(
          radius: 34,
          backgroundColor: const Color(0xFFD6EDF3),
          backgroundImage: instructor.image?.isNotEmpty == true
              ? NetworkImage(instructor.image!)
              : null,
          child: instructor.image?.isNotEmpty == true
              ? null
              : const Icon(Icons.person, color: AppColors.primaryColor)),
      const SizedBox(height: 5),
      SizedBox(
          width: 76,
          child: Text(name.isEmpty ? 'Instructor' : name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)))
    ]);
  }
}

class _LocationPreview extends StatelessWidget {
  const _LocationPreview();
  @override
  Widget build(BuildContext context) => Container(
      height: 112,
      margin: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
          color: const Color(0xFFE0F0F3),
          borderRadius: BorderRadius.circular(12)),
      child: Stack(children: [
        Positioned.fill(child: CustomPaint(painter: _MapPainter())),
        const Center(
            child: Icon(Icons.location_on, color: Color(0xFFE5972D), size: 34))
      ]));
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFB9DCE3)
      ..strokeWidth = 2;
    for (var i = -1; i < 8; i++) {
      canvas.drawLine(
          Offset(0, i * 23.0 + 8), Offset(size.width, i * 23.0 + 31), p);
      canvas.drawLine(
          Offset(i * 45.0, 0), Offset(i * 45.0 - 35, size.height), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
