import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_baby_watch/common/extensions/string_x.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/utils/logger.dart';
import '../cubit/orientation_cubit.dart';
import '../cubit/video_overplay_controller_cubit.dart';

class VideoOverplayLandscape extends StatelessWidget {
  final VideoPlayerController controller;
  final OrientationCubit orientationCubit;
  final VideoOverplayControllerCubit videoOverplayControllerCubit;

  const VideoOverplayLandscape({
    super.key,
    required this.controller,
    required this.orientationCubit,
    required this.videoOverplayControllerCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: orientationCubit),
        BlocProvider.value(value: videoOverplayControllerCubit),
      ],
      child: BlocBuilder<OrientationCubit, OrientationState>(
        builder: (context, stateOrientation) {
          return BlocBuilder<VideoOverplayControllerCubit,
              VideoOverplayControllerState>(
            builder: (context, stateOverplay) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (stateOverplay is VideoOverplayControllerWhenLoading) {
                    videoOverplayControllerCubit.toggleShowControls();
                  } else if (stateOverplay
                      is VideoOverplayControllerWhenPause) {
                    videoOverplayControllerCubit.toggleShowControlsWhenPause();
                  }
                },
                child: Stack(
                  children: <Widget>[
                    if (stateOverplay is VideoOverplayControllerWhenLoading)
                      buildControls(stateOverplay.showControls, context,
                          stateOrientation),
                    if (stateOverplay is VideoOverplayControllerWhenPause)
                      buildControlsWhenPause(
                          stateOverplay.showControls, context, stateOrientation)
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// [buildTimeProgressVideo] Hiển thị thời gian video
  Widget buildTimeProgressVideo(BuildContext context, OrientationState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, VideoPlayerValue value, child) {
                  return DefaultTextStyle(
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    child: Text(
                      ('${value.position.videoDuration()} / ${controller.value.duration.videoDuration()}'),
                    ),
                  );
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Theme.of(context)
                        .colorScheme
                        .secondary, // Màu của phần đã phát
                    bufferedColor: Colors.white54, // Màu của phần đã tải
                    backgroundColor:
                        Theme.of(context).colorScheme.onSurface, // Màu nền
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                orientationCubit.changeOrientation();
                context.router.back();
              },
              child: Icon(
                Icons.fullscreen,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hiển thị các nút điều khiển (play/pause)
  Widget buildButtonControl(BuildContext context, bool isPlaying) {
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
            videoOverplayControllerCubit.pauseVideo(controller);
          } else {
            videoOverplayControllerCubit.resumeVideo(controller);
          }
        },
      ),
    );
  }

  /// [buildButtonTopRight] Hiển thị nút top right
  Widget buildButtonTopRight(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0, top: 48.0),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
            child: Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 25,
            ),
            onTap: () {
              logger.d('More');
            }),
      ),
    );
  }

  /// [buildButtonTopLeft] Hiển thị nút top left
  Widget buildButtonTopLeft(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          child: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 25,
          ),
          onTap: () {
            logger.d('Exit');
            context.router.back();
          },
        ),
      ),
    );
  }

  /// Hiển thị các controls
  Widget buildControls(
      bool showControls, BuildContext context, OrientationState state) {
    return IgnorePointer(
      ignoring:
          !showControls, // Vô hiệu hóa tương tác nếu showControls = false(
      child: AnimatedOpacity(
        opacity: showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            buildButtonControl(context, true),
            buildTimeProgressVideo(context, state),
            buildButtonTopLeft(context),
          ],
        ),
      ),
    );
  }

  /// Hiển thị các controls khi tạm dừng
  Widget buildControlsWhenPause(
      bool showControls, BuildContext context, OrientationState state) {
    return IgnorePointer(
      ignoring: !showControls, // Vô hiệu hóa tương tác nếu showControls = false
      child: AnimatedOpacity(
        opacity: showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            buildButtonControl(context, false),
            buildTimeProgressVideo(context, state),
            buildButtonTopLeft(context),
          ],
        ),
      ),
    );
  }

  /// [buildSliderIndicator] Hiển thị thanh trượt video
  Widget buildSliderIndicator() {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2.0, // Độ dày của thanh Slider
            thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 6.0), // Độ lớn của nút kéo
            overlayShape: SliderComponentShape
                .noOverlay, // Loại bỏ hiệu ứng overlay của thumb
          ),
          child: Slider(
            activeColor: Theme.of(context).colorScheme.secondary,
            inactiveColor: Colors.white54,
            value: value.position.inSeconds.toDouble(),
            min: 0,
            max: value.duration.inSeconds.toDouble(),
            onChangeStart: (_) {
              // Bắt đầu tương tác, thông báo để giữ controls hiển thị
              context.read<VideoOverplayControllerCubit>().onUserInteraction();
            },
            onChanged: (double newValue) {
              controller.seekTo(Duration(seconds: newValue.toInt()));
            },
            onChangeEnd: (_) {
              // Kết thúc tương tác, gia hạn thời gian hiển thị controls
              context.read<VideoOverplayControllerCubit>().onUserInteraction();
            },
          ),
        );
      },
    );
  }
}
