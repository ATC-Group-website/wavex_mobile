import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/features/instructors_screen/logic/instructors_cubit.dart';

import '../../../core/components/bottom_navigation_bar.dart';
import '../../../core/components/bottom_wave_painter.dart';
import '../../../core/components/header_widget.dart';
import '../../home_screen/data/models/get_instructors_response.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({Key? key, required this.instructorId})
      : super(key: key);

  final int instructorId;

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  int selectedInstructorIndex = 0;
  List<InstructorData> instructors = [];
  List<InstructorData> visibleInstructors = [];
  InstructorData? selectedInstructor;
  bool _initialized = false;

  int currentPage = 0;
  final int itemsPerPage = 3;
  int startIndex = 0;
  int endIndex = 0;

  @override
  void initState() {
    super.initState();
    InstructorsCubit.get(context).getInstructors();
  }

  void _updateVisibleInstructors() {
    if (instructors.isEmpty) return;

    setState(() {
      startIndex = currentPage * itemsPerPage;
      endIndex = (startIndex + itemsPerPage > instructors.length)
          ? instructors.length
          : startIndex + itemsPerPage;

      visibleInstructors = instructors.sublist(startIndex, endIndex);

      selectedInstructor = instructors[selectedInstructorIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(isWithBack: true),
          BlocConsumer<InstructorsCubit, InstructorsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetInstructorsSuccessState) {
                instructors = state.instructorsResponse.data ?? [];

                if (instructors.isNotEmpty) {
                  if (!_initialized) {
                    final index = instructors
                        .indexWhere((inst) => inst.id == widget.instructorId);

                    if (index != -1) {
                      selectedInstructorIndex = index;
                      selectedInstructor = instructors[index];
                      currentPage = index ~/ itemsPerPage;
                    } else {
                      selectedInstructorIndex = 0;
                      selectedInstructor = instructors.first;
                      currentPage = 0;
                    }

                    _initialized = true; // ✅ خلاص حددنا مرة واحدة
                  }

                  startIndex = currentPage * itemsPerPage;
                  endIndex = (startIndex + itemsPerPage > instructors.length)
                      ? instructors.length
                      : startIndex + itemsPerPage;
                  visibleInstructors =
                      instructors.sublist(startIndex, endIndex);
                }
              }

              if (instructors.isEmpty) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 24),
                      _buildCarousel(),
                      const SizedBox(height: 32),
                      if (selectedInstructor != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4F8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              InstructorProfileCard(
                                  instructor: selectedInstructor!),
                              const SizedBox(height: 16),
                              Text(
                                selectedInstructor?.bio ?? "",
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF45818B),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 24),
                              QualificationsSection(
                                qualifications:
                                    selectedInstructor?.specializations ?? [],
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 16),
                        // ExperienceSection(
                        //   experiences:
                        //   selectedInstructor?.specializations ?? [],
                        // ),
                        const SizedBox(height: 100),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
          const BottomNavigation(currentIndex: 0),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/water_drop_icon.png"),
            const SizedBox(width: 12),
            Text(
              'Meet Our Instructors',
              style: GoogleFonts.inter().copyWith(
                color: const Color(0xFF45818B),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     CircleAvatar(
        //       radius: 4,
        //       backgroundColor: AppColors.primaryColor,
        //     ),
        //     SizedBox(width: 8),
        //     Text(
        //       'Meet Our Instructors',
        //       style: TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.w600,
        //         color: AppColors.primaryColor,
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(height: 8),
        Center](
          child: Text(
            'Find Your Favorite instructor now and know more about them',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF45818B),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        // 🎯 Responsive sizes
        double itemSize = 50;
        double selectedItemSize = 80;
        int itemsPerPage = 3;

        if (screenWidth > 1200) {
          // Large screen (Web / Desktop)
          itemSize = 100;
          selectedItemSize = 130;
          itemsPerPage = 6;
        } else if (screenWidth > 800) {
          // Tablet
          itemSize = 80;
          selectedItemSize = 100;
          itemsPerPage = 4;
        }

        return SizedBox(
          height: selectedItemSize + 40,
          child: Row(
            children: [
              IconButton(
                onPressed: currentPage > 0
                    ? () {
                  setState(() {
                    currentPage--;
                    _updateVisibleInstructors();
                  });
                }
                    : null,
                icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF26C6DA)),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < visibleInstructors.length; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedInstructorIndex = startIndex + i;
                            selectedInstructor =
                            instructors[selectedInstructorIndex];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                width: (startIndex + i == selectedInstructorIndex)
                                    ? selectedItemSize
                                    : itemSize,
                                height: (startIndex + i == selectedInstructorIndex)
                                    ? selectedItemSize
                                    : itemSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: (startIndex + i == selectedInstructorIndex)
                                      ? Border.all(
                                    color: AppColors.primaryColor,
                                    width: 2,
                                  )
                                      : null,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      visibleInstructors[i].image ?? "",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (startIndex + i == selectedInstructorIndex) ...[
                                const SizedBox(height: 6),
                                Text(
                                  visibleInstructors[i].firstName ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: endIndex < instructors.length
                    ? () {
                  setState(() {
                    currentPage++;
                    _updateVisibleInstructors();
                  });
                }
                    : null,
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFF26C6DA)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InstructorProfileCard extends StatelessWidget {
  final InstructorData instructor;

  const InstructorProfileCard({Key? key, required this.instructor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
                "Instructor",
                style: GoogleFonts.inter(
                  color: const Color(0xFFF30F0F),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${instructor.firstName??''} ${instructor.lastName??""}" ,
                style:  GoogleFonts.inter(
                  color: const Color(0xFF45818B),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // instructor.phone != null
              //     ? const SizedBox(height: 4)
              //     : SizedBox.shrink(),
              // instructor.phone != null
              //     ? Text(
              //         instructor.phone ?? "",
              //         style: const TextStyle(
              //           fontSize: 14,
              //           color: AppColors.primaryColor,
              //         ),
              //       )
              //     : SizedBox.shrink(),
            ],
          ),
        ),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(instructor.image ?? ""),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class QualificationsSection extends StatelessWidget {
  final List<String> qualifications;

  const QualificationsSection({Key? key, required this.qualifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (qualifications.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Specialization & Qualifications:',
            style: GoogleFonts.inter(
              color: const Color(0xFF2E535F),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.93,
            ),
          ),
          const SizedBox(height: 12),
          ...qualifications.map(
            (qualification) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF2E535F),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.93,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      qualification,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF2E535F),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.93,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceSection extends StatelessWidget {
  final List<String> experiences;

  const ExperienceSection({Key? key, required this.experiences})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (experiences.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Previous Fitness Experience:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ...experiences.map(
            (exp) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 16)),
                  Expanded(
                    child: Text(
                      exp,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
