import 'package:flutter/material.dart';

class ButtonControl extends StatelessWidget {
  const ButtonControl(
      {super.key,
      required this.isPlaying,
      required this.onPressedWhenPlaying,
      required this.onPressedWhenPaused});

  final bool isPlaying;

  final VoidCallback onPressedWhenPlaying;

  final VoidCallback onPressedWhenPaused;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black26,
      child: IconButton(
        icon: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 50,
        ),
        onPressed: () {
          if (isPlaying) {
            onPressedWhenPlaying();
          } else {
            onPressedWhenPaused();
          }
        },
      ),
    );
  }
}
