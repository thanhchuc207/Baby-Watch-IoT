import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = LinearGradient(
        // Updated the color gradient to use more vibrant and educational colors
        colors: [
          Color(0xFF4DD0E1),
          Color(0xFF00A9B8)
        ], // Primary and secondary colors
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    var path = Path();
    // Updated the path to make it look like a smooth wave that could represent dynamic learning paths
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.5,
        size.width * 0.35, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.60, size.height * 0.85, size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return true to repaint for dynamic changes
    return true;
  }
}
