import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/video_controller_cubit.dart';
import 'video_overplay.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String urlVideo;
  const VideoPlayerWidget({
    super.key,
    required this.urlVideo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoControllerCubit, VideoControllerState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black12, // Màu nền loading
                child: const Center(
                  child: CircularProgressIndicator(), // Thêm vòng quay loading
                ),
              ),
            ),
          );
        }
        if (state is VideoLoadError) {
          return Center(
              child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<VideoControllerCubit>()
                          .initializeVideo(urlVideo);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ));
        }
        if (state is VideoLoaded) {
          return Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Center(
                    child: SizedBox.expand(
                      // Đảm bảo video chiếm toàn bộ kích thước
                      child: VideoPlayer(state.controller),
                    ),
                  ),
                  // Overlay video
                  Positioned.fill(
                    child: VideoOverplay(
                      controller: state.controller,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
