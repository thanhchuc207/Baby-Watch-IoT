import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_baby_watch/common/extensions/string_x.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/utils/logger.dart';
import '../../../core/app/app_router.dart';
import '../cubit/orientation_cubit.dart';
import '../cubit/video_overplay_controller_cubit.dart';
import 'widget_on_surface_video/button_control.dart';
import 'widget_on_surface_video/button_top_left.dart';
import 'widget_on_surface_video/button_top_right.dart';
import 'widget_on_surface_video/video_progress_indicator_widget.dart';

class VideoOverplay extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoOverplay({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrientationCubit, OrientationState>(
      builder: (context, stateOrientation) {
        return BlocBuilder<VideoOverplayControllerCubit,
            VideoOverplayControllerState>(
          builder: (context, stateOverplay) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (stateOverplay is VideoOverplayControllerWhenLoading) {
                  context
                      .read<VideoOverplayControllerCubit>()
                      .toggleShowControls();
                } else if (stateOverplay is VideoOverplayControllerWhenPause) {
                  context
                      .read<VideoOverplayControllerCubit>()
                      .toggleShowControlsWhenPause();
                }
              },
              child: Stack(
                children: <Widget>[
                  if (stateOverplay is VideoOverplayControllerWhenLoading)
                    buildControls(
                        stateOverplay.showControls, context, stateOrientation),
                  if (stateOverplay is VideoOverplayControllerWhenPause)
                    buildControlsWhenPause(
                        stateOverplay.showControls, context, stateOrientation)
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// [buildTimeProgressVideo] Hiển thị thời gian video
  Widget buildTimeProgressVideo(BuildContext context, OrientationState state) {
    return Positioned(
      bottom: 0,
      left: 16,
      right: 16,
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
              child: buildSliderIndicator(),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<OrientationCubit>().changeOrientation();
              context.router.push(
                LandscapeModeVideosRoute(
                  controller: controller,
                  videoOverplayControllerCubit:
                      context.read<VideoOverplayControllerCubit>(),
                  orientationCubit: context.read<OrientationCubit>(),
                ),
              );
            },
            child: Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  void _onTapButtonTopRight(BuildContext context) {
    logger.d('More');
  }

  void _onTapButtonTopLeft(BuildContext context) {
    logger.d('Exit');
    context.router.back();
  }

  void _onPressedWhenPlaying(BuildContext context) {
    context.read<VideoOverplayControllerCubit>().pauseVideo(controller);
  }

  void _onPressedWhenPaused(BuildContext context) {
    context.read<VideoOverplayControllerCubit>().resumeVideo(controller);
  }

  /// [buildControls] Hiển thị các controls khi video đang chạy
  Widget buildControls(
      bool showControls, BuildContext context, OrientationState state) {
    if (!showControls) {
      // Trả về widget khác khi showControls = false
      return VideoProgressIndicatorWidget(controller: controller);
    }
    return IgnorePointer(
      ignoring:
          !showControls, // Vô hiệu hóa tương tác nếu showControls = false(
      child: AnimatedOpacity(
        opacity: showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            ButtonControl(
                isPlaying: controller.value.isPlaying,
                onPressedWhenPlaying: () => _onPressedWhenPlaying(context),
                onPressedWhenPaused: () => _onPressedWhenPaused(context)),
            buildTimeProgressVideo(context, state),
            ButtonTopRight(
              onTap: () => _onTapButtonTopRight(context),
            ),
            ButtonTopLeft(
              onTap: () => _onTapButtonTopLeft(context),
            ),
          ],
        ),
      ),
    );
  }

  /// [buildControlsWhenPause] Hiển thị các controls khi video đang pause
  Widget buildControlsWhenPause(
      bool showControls, BuildContext context, OrientationState state) {
    if (!showControls) {
      // Trả về widget khác khi showControls = false
      return VideoProgressIndicatorWidget(controller: controller);
    }
    return IgnorePointer(
      ignoring: !showControls, // Vô hiệu hóa tương tác nếu showControls = false
      child: AnimatedOpacity(
        opacity: showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            ButtonControl(
                isPlaying: controller.value.isPlaying,
                onPressedWhenPlaying: () => _onPressedWhenPlaying(context),
                onPressedWhenPaused: () => _onPressedWhenPaused(context)),
            buildTimeProgressVideo(context, state),
            ButtonTopRight(
              onTap: () => _onTapButtonTopRight(context),
            ),
            ButtonTopLeft(
              onTap: () => _onTapButtonTopLeft(context),
            ),
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
