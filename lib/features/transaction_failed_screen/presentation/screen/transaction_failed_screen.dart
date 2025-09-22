import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/main.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/header_widget.dart';
import '../../../book_program_screen/logic/book_program_cubit.dart';

class TransactionFailedScreen extends StatelessWidget {
  const TransactionFailedScreen({Key? key, this.sessionId ,this.label}) : super(key: key);

  final int? sessionId;
  final String? label;


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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Title
                      Text(
                        'Your Transaction',
                        style: GoogleFonts.inter().copyWith(
                          color: const Color(0xFF44858F),
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Failed transaction card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFD70404),
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
                            // Failed icon (X)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: const Color(0xFFD70404),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Failed text
                            Text(
                              label ??'Failed',
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: const Color(0xFFD70404),
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            //
                            // const SizedBox(height: 20),
                            //
                            // // Total price
                            // Text('Total Price : 2000 GBP',
                            //     style: GoogleFonts.leagueSpartan().copyWith(
                            //       color: const Color(0xFFD70404),
                            //       fontSize: 21,
                            //       fontWeight: FontWeight.w600,
                            //     )),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Action buttons
                      Row(
                        children: [
                          // Try Again button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle try again action
                                if (sessionId != null) {
                                  // استدعي عملية الدفع من Cubit
                                  BookProgramCubit.get(context).payment(sessionId: sessionId!);

                                  // ممكن تعمل pop علشان يرجع تاني لشاشة BookProgramScreen
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("No session found to retry payment"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                // ScaffoldMessenger.of(context)
                                //   ..hideCurrentSnackBar()
                                //   ..showSnackBar(
                                //     const SnackBar(
                                //       content: Text('Retrying transaction...'),
                                //       backgroundColor: Color(0xFF26C6DA),
                                //     ),
                                //   );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                // padding:
                                //     const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Center(
                                child: Text(
                                  'Try Again',
                                  style: GoogleFonts.inter().copyWith(
                                    color: AppColors.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Home button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to home
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
                                //     const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                'Home',
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
