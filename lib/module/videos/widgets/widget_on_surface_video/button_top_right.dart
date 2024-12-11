import 'package:flutter/material.dart';

class ButtonTopRight extends StatelessWidget {
  const ButtonTopRight({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 25,
            )),
      ),
    );
  }
}
