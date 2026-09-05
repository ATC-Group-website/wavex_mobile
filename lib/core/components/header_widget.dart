import 'package:flutter/material.dart';
import 'bottom_wave_painter.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, this.onTap, this.isWithBack});

  final bool? isWithBack;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .15,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .15,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4BC0DA),
                  Color(0xFF47A5B8),
                  Color(0xC9456D73)
                ],
              ),
            ),
            child: Stack(
              children: [
                // Keep the logo centered relative to the full screen. Placing
                // it in a Row after the back button shifts it to the right.
                Center(
                  child: Image.asset("assets/images/wavx_home_logo.png"),
                ),
                if (isWithBack != null)
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: InkWell(
                        onTap: onTap ??
                            () {
                              Navigator.pop(context);
                            },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 0),
              painter: BottomWavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}
