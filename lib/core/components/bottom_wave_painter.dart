import 'package:flutter/material.dart';
import 'dart:math' as math;

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x846DAEB8) ..style = PaintingStyle.fill;
    final path = Path()..moveTo(0, size.height);

    // Smooth sin-like wave
    for (double x = 0; x <= size.width; x++) {
      final y =
          size.height - 22 + 12 * math.sin((x / size.width) * 2 * math.pi);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
