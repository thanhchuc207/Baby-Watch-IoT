import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double topPadding;
  final double leftPadding;
  final double rightPadding;
  final double bottomPadding;

  const SectionTitle({
    super.key,
    required this.title,
    this.topPadding = 16.0, // Thiết lập giá trị mặc định cho padding
    this.leftPadding = 16.0,
    this.rightPadding = 16.0,
    this.bottomPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: leftPadding,
          right: rightPadding,
          top: topPadding,
          bottom: bottomPadding),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
