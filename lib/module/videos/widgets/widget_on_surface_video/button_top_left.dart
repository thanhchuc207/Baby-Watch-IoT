import 'package:flutter/material.dart';

class ButtonTopLeft extends StatelessWidget {
  const ButtonTopLeft({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: onTap,
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }
}
