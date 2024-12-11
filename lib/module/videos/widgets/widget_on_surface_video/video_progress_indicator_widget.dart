import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressIndicatorWidget extends StatelessWidget {
  const VideoProgressIndicatorWidget({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: VideoProgressIndicator(
        controller,
        allowScrubbing: true,
        colors: VideoProgressColors(
          playedColor:
              Theme.of(context).colorScheme.secondary, // Màu của phần đã phát
          bufferedColor: Colors.white54, // Màu của phần đã tải
          backgroundColor: Theme.of(context).colorScheme.onSurface, // Màu nền
        ),
      ),
    );
  }
}
