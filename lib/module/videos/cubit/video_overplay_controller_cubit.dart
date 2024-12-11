import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

part 'video_overplay_controller_state.dart';

class VideoOverplayControllerCubit extends Cubit<VideoOverplayControllerState> {
  Timer? _hideTimer;

  VideoOverplayControllerCubit() : super(VideoOverplayControllerWhenLoading());

  void toggleShowControls() {
    if (state is VideoOverplayControllerWhenLoading) {
      final currentState = state as VideoOverplayControllerWhenLoading;
      final newState =
          currentState.copyWith(showControls: !currentState.showControls);

      emit(newState);

      // Nếu controls được bật, bắt đầu hẹn giờ để tự động ẩn
      if (newState.showControls) {
        _startHideTimer();
      } else {
        _hideTimer?.cancel(); // Dừng hẹn giờ nếu controls bị ẩn thủ công
      }
    }
  }

  void toggleShowControlsWhenPause() {
    if (state is VideoOverplayControllerWhenPause) {
      final currentState = state as VideoOverplayControllerWhenPause;
      final newState =
          currentState.copyWith(showControls: !currentState.showControls);

      emit(newState);
    }
  }

  void onUserInteraction() {
    if (state is VideoOverplayControllerWhenLoading) {
      final currentState = state as VideoOverplayControllerWhenLoading;
      if (!currentState.showControls) {
        emit(currentState.copyWith(showControls: true));
      }
      _startHideTimer(); // Gia hạn hẹn giờ
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel(); // Hủy bỏ bất kỳ timer nào đang chạy
    _hideTimer = Timer(const Duration(seconds: 2), () {
      // Ẩn controls sau 2 giây
      if (state is VideoOverplayControllerWhenLoading) {
        final currentState = state as VideoOverplayControllerWhenLoading;
        emit(currentState.copyWith(showControls: false));
      }
    });
  }

  void pauseVideo(VideoPlayerController controller) {
    controller.pause();
    emit(VideoOverplayControllerWhenPause());
  }

  void resumeVideo(VideoPlayerController controller) {
    controller.play();
    emit(VideoOverplayControllerWhenLoading(true));
    _startHideTimer();
  }

  @override
  Future<void> close() {
    _hideTimer?.cancel(); // Hủy timer khi Cubit bị đóng
    return super.close();
  }
}
