import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/theme/colors.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../main.dart';

class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              HeaderWidget(
                isWithBack: true,
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Title
                      Text('Your Transaction',
                          style: GoogleFonts.inter().copyWith(
                            color: const Color(0xFF44858F),
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                          )),

                      const SizedBox(height: 40),

                      // Success Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF20C997),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Success Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: const Color(0xFF20C997),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Success Text
                            Text(
                              'Successful',
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: const Color(0xFF20C997),
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // const SizedBox(height: 20),
                            //
                            // // Total Price
                            // Text('Total Price : 2000 GBP',
                            //     style: GoogleFonts.leagueSpartan().copyWith(
                            //       color: const Color(0xFF20C997),
                            //       fontSize: 21,
                            //       fontWeight: FontWeight.w600,
                            //     )),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Action Buttons
                      Row(
                        children: [
                          // Share Button
                          Expanded(
                            flex: 1,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Share.share(
                                  'Transaction Successful! Total Price: 2000 GBP',
                                  subject: 'WaveX Transaction Receipt',
                                );
                              },
                              icon: Icon(
                                Icons.share,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                              label: const Text(''),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF26C6DA),
                                side: const BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                // padding:
                                //     const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Home Button
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to home screen
                                navigatorKey.currentState!
                                    .pushNamedAndRemoveUntil(
                                  RouteStrings.homeScreen,
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                // padding:
                                //     const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0),
                painter: BottomWavePainter(),
              ),
              const BottomNavigation(
                currentIndex: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
