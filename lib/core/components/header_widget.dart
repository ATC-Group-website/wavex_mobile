import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'bottom_wave_painter.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({super.key, this.onTap, this.isWithBack});

  bool? isWithBack;
  Function()? onTap;

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isWithBack != null
                      ? InkWell(
                          onTap: onTap ??
                              () {
                                Navigator.pop(context);
                              },
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                          ),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: Center(
                      child: Image.asset("assets/images/wavx_home_logo.png"),
                    ),
                  ),
                ],
              ),
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
