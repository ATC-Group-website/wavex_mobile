import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/features/classes_screen/data/models/get_programs_response.dart';
import 'package:wavex/features/classes_screen/logic/programs_cubit.dart';
import 'package:wavex/main.dart';

import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/colors.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  int _currentImageIndex = 0;
  int _currentIndex = 1;
  int _selectedBottomNavIndex = 1; // Dumbbell icon is selected

  final List<String> _heroImages = [
    'assets/demo/2.jpg',
    'assets/demo/7.jpg',
    'assets/demo/blog hero design.png',
  ];

  int selectedIndex = -1;
  List<ProgramData> programs = [];

  @override
  void initState() {
    ProgramsCubit.get(context).getPrograms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderWidget(isWithBack: true),
          Expanded(
            child: Column(
              children: [
                _buildExploreSection(),
                _buildHeroImageCarousel(),
                _buildClassCategories(),
              ],
            ),
          ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
          BottomNavigation(currentIndex: _currentIndex),
        ],
      ),
    );
  }

  Widget _buildExploreSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Image.asset("assets/images/water_drop_icon.png"),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context).translate("classes_explore"),
            style: GoogleFonts.inter().copyWith(
              color: const Color(0xFF2E535F),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImageCarousel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: _heroImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      _heroImages[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.fitness_center,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _heroImages.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? const Color(0xFF4DB6AC)
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCategories() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<ProgramsCubit, ProgramsState>(
          builder: (context, state) {
            if (programs.isNotEmpty) {
              return ListView.builder(
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final classItem = programs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedIndex == classItem.id
                          ? AppColors.primaryColor
                          : const Color(0xFFE2F2F5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/water_drop_icon.png",
                              color: selectedIndex == classItem.id
                                  ? Colors.white
                                  : AppColors.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                classItem.name ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: selectedIndex == classItem.id
                                      ? Colors.white
                                      : const Color(0xFF2E535F),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffA5CFD6),
                                foregroundColor: Colors.white,
                                shadowColor: Colors.black26,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 2,
                                    color: selectedIndex == classItem.id
                                        ? Colors.white
                                        : AppColors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedIndex = classItem.id ?? 0;
                                });
                                Timer(
                                  const Duration(microseconds: 50),
                                  () => navigatorKey.currentState!.pushNamed(
                                    RouteStrings.bookProgramScreen,
                                    arguments: {"id": classItem.id ?? 0},
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("classes_book_now"),
                                style: GoogleFonts.inter().copyWith(
                                  color: selectedIndex == classItem.id
                                      ? Colors.white
                                      : const Color(0xCC23707C),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          classItem.subtitle ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: selectedIndex == classItem.id
                                ? Colors.white
                                : const Color(0xCC23707C),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
          listener: (context, state) {
            if (state is GetProgramsSuccessState) {
              setState(() {
                programs = state.programsResponse.data ?? [];
              });
            }
          },
        ),
      ),
    );
  }
}
