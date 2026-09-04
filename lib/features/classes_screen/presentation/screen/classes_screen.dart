import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/bottom_navigation_bar.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/features/classes_screen/data/models/get_programs_response.dart';
import 'package:wavex/features/classes_screen/logic/programs_cubit.dart';
import 'package:wavex/main.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});
  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  List<ProgramData> _programs = const [];
  int? _expandedProgramId;
  int _heroIndex = 0;

  @override
  void initState() {
    super.initState();
    ProgramsCubit.get(context).getPrograms();
  }

  void _book(ProgramData program) =>
      navigatorKey.currentState!.pushNamed(RouteStrings.bookProgramScreen,
          arguments: {'id': program.id ?? 0});

  @override
  Widget build(BuildContext context) =>
      BlocListener<ProgramsCubit, ProgramsState>(
        listener: (context, state) {
          if (state is GetProgramsSuccessState) {
            setState(() => _programs = state.programsResponse.data ?? const []);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FBFC),
          body: SafeArea(
              child: Column(children: [
            const _ProgramsHeader(),
            Expanded(
                child: _programs.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                        children: [
                            const _ExploreTitle(),
                            const SizedBox(height: 10),
                            _ProgramHero(
                                programs: _programs,
                                index: _heroIndex,
                                onChanged: (index) =>
                                    setState(() => _heroIndex = index)),
                            const SizedBox(height: 18),
                            ..._programs.asMap().entries.map((entry) {
                              final program = entry.value;
                              final image =
                                  program.coverImage?.isNotEmpty == true
                                      ? program.coverImage
                                      : program.mainImage;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ProgramCard(
                                  program: program,
                                  imageUrl: image,
                                  expanded: _expandedProgramId == program.id,
                                  onToggle: () => setState(() =>
                                      _expandedProgramId =
                                          _expandedProgramId == program.id
                                              ? null
                                              : program.id),
                                  onBook: () => _book(program),
                                ),
                              );
                            }),
                          ])),
            const BottomNavigation(currentIndex: 1),
          ])),
        ),
      );
}

class _ProgramsHeader extends StatelessWidget {
  const _ProgramsHeader();
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 78,
      child: Stack(children: [
        Container(
            decoration: const BoxDecoration(
                color: Color(0xFFD6EDF3),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.elliptical(210, 24)))),
        Center(
            child: Image.asset('assets/images/wavx_home_logo.png', width: 122)),
      ]));
}

class _ExploreTitle extends StatelessWidget {
  const _ExploreTitle();
  @override
  Widget build(BuildContext context) => Row(children: [
        const Icon(Icons.water_drop, color: AppColors.primaryColor, size: 20),
        const SizedBox(width: 10),
        Text('Explore WaveX Classes',
            style: GoogleFonts.inter(
                color: const Color(0xFF315762),
                fontSize: 16,
                fontWeight: FontWeight.w700))
      ]);
}

class _ProgramHero extends StatelessWidget {
  const _ProgramHero(
      {required this.programs, required this.index, required this.onChanged});
  final List<ProgramData> programs;
  final int index;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
            height: 112,
            child: PageView.builder(
                itemCount: programs.length,
                onPageChanged: onChanged,
                itemBuilder: (_, page) {
                  final image = programs[page].mainImage;
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: image?.isNotEmpty == true
                          ? Image.network(image!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/demo/Rectangle 125.png',
                                  width: double.infinity,
                                  fit: BoxFit.cover))
                          : Image.asset('assets/demo/Rectangle 125.png',
                              width: double.infinity, fit: BoxFit.cover));
                })),
        const SizedBox(height: 9),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                programs.length.clamp(0, 5),
                (dot) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dot == index
                            ? const Color(0xFF58A3B8)
                            : const Color(0xFFB9DDE4))))),
      ]);
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard(
      {required this.program,
      required this.imageUrl,
      required this.expanded,
      required this.onToggle,
      required this.onBook});
  final ProgramData program;
  final String? imageUrl;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onBook;
  @override
  Widget build(BuildContext context) {
    final subtitle = program.subtitle?.trim();
    final description = program.description?.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          constraints: BoxConstraints(minHeight: expanded ? 0 : 66),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              color: expanded ? Colors.white : const Color(0xFFE0F2F5),
              borderRadius: BorderRadius.circular(14)),
          child: AnimatedCrossFade(
            firstChild: _CollapsedProgramCard(
              programName: program.name ?? 'WaveX Program',
              subtitle: subtitle,
              onBook: onBook,
            ),
            secondChild: _ExpandedProgramCard(
              programName: program.name ?? 'WaveX Program',
              description: description?.isNotEmpty == true
                  ? description!
                  : (subtitle ??
                      'Discover this WaveX class and book your next session.'),
              imageUrl: imageUrl,
              onBook: onBook,
            ),
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
            firstCurve: Curves.easeOutCubic,
            secondCurve: Curves.easeOutCubic,
            sizeCurve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }
}

class _CollapsedProgramCard extends StatelessWidget {
  const _CollapsedProgramCard(
      {required this.programName,
      required this.subtitle,
      required this.onBook});
  final String programName;
  final String? subtitle;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.water_drop, color: AppColors.primaryColor, size: 19),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(programName,
                    style: GoogleFonts.inter(
                        color: const Color(0xFF315762),
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
                if (subtitle?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!,
                      style: const TextStyle(
                          color: Color(0xFF4C8797), fontSize: 12))
                ],
              ])),
          const SizedBox(width: 10),
          _PillButton(label: 'Book Now', onPressed: onBook),
        ]),
      );
}

class _ExpandedProgramCard extends StatelessWidget {
  const _ExpandedProgramCard(
      {required this.programName,
      required this.description,
      required this.imageUrl,
      required this.onBook});
  final String programName;
  final String description;
  final String? imageUrl;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.water_drop,
                  color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(programName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: const Color(0xFF315762),
                        fontWeight: FontWeight.w800,
                        fontSize: 15)),
              ),
            ]),
            const SizedBox(height: 14),
            Text(description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF4C8797), height: 1.35, fontSize: 14)),
          ]),
        ),
        if (imageUrl?.isNotEmpty == true)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(imageUrl!,
                height: 145,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                    'assets/demo/Rectangle 125.png',
                    height: 145,
                    width: double.infinity,
                    fit: BoxFit.cover)),
          ),
        Container(
          width: double.infinity,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFE0F2F5),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
          ),
          child: TextButton(
              onPressed: onBook,
              child: const Text('Book Now',
                  style: TextStyle(
                      color: Color(0xFF315762),
                      fontSize: 15,
                      fontWeight: FontWeight.w800))),
        ),
      ]);
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 26,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF315762),
              elevation: 0,
              shape: const StadiumBorder()),
          child: Text(label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))));
}
