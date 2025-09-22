import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/theme/colors.dart';
import '../../../../main.dart';

class ScheduleTimeScreen extends StatefulWidget {
  const ScheduleTimeScreen({super.key});

  @override
  State<ScheduleTimeScreen> createState() => _ScheduleTimeScreenState();
}

class _ScheduleTimeScreenState extends State<ScheduleTimeScreen> {
  int _currentNavIndex = 1; // Dumbbell icon selected
  int _seatCount = 1;
  Set<String> _selectedTimes = {'12:30 PM', '4:30 PM', '6:30 PM'};
  bool _isBooking = false;

  final List<TimeSlot> _timeSlots = [
    TimeSlot(time: '9:30 AM', isAvailable: true),
    TimeSlot(time: '12:30 PM', isAvailable: true),
    TimeSlot(time: '2:30 PM', isAvailable: true),
    TimeSlot(time: '4:30 PM', isAvailable: true),
    TimeSlot(time: '6:30 PM', isAvailable: true),
    TimeSlot(time: '8:30 PM', isAvailable: true),
    TimeSlot(time: '10:30 PM', isAvailable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(isWithBack: true,),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Available Times header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Image.asset("assets/images/water_drop_icon.png"),
                        const SizedBox(width: 12),
                        Text('Available Times',
                            style: GoogleFonts.inter().copyWith(
                              color: const Color(0xFF2E535F),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Location and Date info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Location2',
                            style: GoogleFonts.inter().copyWith(
                              color: const Color(0xFF2E535F),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            )),
                        Text('1 - Thursday - 2025',
                            style: GoogleFonts.inter().copyWith(
                              color: const Color(0xCC23707C),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Seats counter
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Seats',
                            style: GoogleFonts.inter().copyWith(
                              color: const Color(0xFF2E535F),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed:
                                    _seatCount > 1 ? _decrementSeats : null,
                                icon: const Icon(
                                  Icons.remove,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(_seatCount.toString(),
                                style: GoogleFonts.inter().copyWith(
                                  color: const Color(0xFF44858F),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(width: 16),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: _incrementSeats,
                                icon: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pick a Time section
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .9,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F2F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pick a Time',
                            style: GoogleFonts.inter().copyWith(
                              color: const Color(0xFF2E535F),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width *.8,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(child: _buildTimeSlotGrid()),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Book Now button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isBooking ? null : _handleBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: _isBooking
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            :  Text(
                                'Book Now',
                                style: GoogleFonts.inter().copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60), // Space for bottom nav
                ],
              ),
            ),
          ),

          // Bottom wave decoration
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
          BottomNavigation(
            currentIndex: _currentNavIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _timeSlots.map((timeSlot) {
        final isSelected = _selectedTimes.contains(timeSlot.time);
        Color backgroundColor;
        Color textColor;

        if (isSelected) {
          // Alternate between red and teal for selected items
          if (timeSlot.time == '12:30 PM' || timeSlot.time == '6:30 PM') {
            backgroundColor = const Color(0xFFE53E3E); // Red
            textColor = Colors.white;
          } else {
            backgroundColor = AppColors.primaryColor; // Teal
            textColor = Colors.white;
          }
        } else {
          backgroundColor = Colors.white;
          textColor = const Color(0xFF333333);
        }

        return GestureDetector(
          onTap: () => _toggleTimeSlot(timeSlot.time),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected ? Colors.transparent : const Color(0xFFE0E0E0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              timeSlot.time,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF26C6DA)
                  : const Color(0xFF999999),
              size: 24,
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? const Color(0xFF26C6DA) : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _incrementSeats() {
    setState(() {
      _seatCount++;
    });
  }

  void _decrementSeats() {
    if (_seatCount > 1) {
      setState(() {
        _seatCount--;
      });
    }
  }

  void _toggleTimeSlot(String time) {
    setState(() {
      if (_selectedTimes.contains(time)) {
        _selectedTimes.remove(time);
      } else {
        _selectedTimes.add(time);
      }
    });
  }

  Future<void> _handleBooking() async {
    if (_selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
        const SnackBar(
          content: Text('Please select at least one time slot'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isBooking = false;
    });
    // navigatorKey.currentState!.pushNamed(RouteStrings.contactUsScreen);
    // Show success message
    ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
      SnackBar(
        content: Text(
            'Successfully booked ${_selectedTimes.length} time slot(s) for $_seatCount seat(s)!'),
        backgroundColor: const Color(0xFF26C6DA),
      ),
    );
  }
}

class TimeSlot {
  final String time;
  final bool isAvailable;

  TimeSlot({
    required this.time,
    required this.isAvailable,
  });
}
