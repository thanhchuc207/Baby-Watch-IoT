import 'package:flutter/material.dart';
import 'dart:math';

class CircularPercentageWidget extends StatelessWidget {
  final double percentage;

  const CircularPercentageWidget({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20, // Tăng kích thước để hiển thị rõ ràng hơn
      height: 20,
      child: CustomPaint(
        painter: CircularPainter(percentage, context),
        child: Center(
          child: Container(
            width: 8, // Chỉnh kích thước chấm tròn ở giữa
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: percentage < 100
                  ? Colors.grey.shade300
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}

class CircularPainter extends CustomPainter {
  final double percentage;
  final BuildContext context;

  CircularPainter(this.percentage, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 2.0; // Tăng độ dày của viền
    double radius = (size.width - lineWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Vẽ viền nền màu xám (background)
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Vẽ viền màu xanh tương ứng với phần trăm
    Paint foregroundPaint = Paint()
      ..color = Theme.of(context).colorScheme.secondary
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Bắt đầu từ đỉnh
      sweepAngle, // Góc quét tương ứng với phần trăm
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
