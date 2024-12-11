import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/utils/logger.dart';

part 'video_controller_state.dart';

class VideoControllerCubit extends Cubit<VideoControllerState> {
  VideoPlayerController? _controller;

  VideoControllerCubit() : super(VideoLoading());

  void initializeVideo(String url) async {
    try {
      emit(VideoLoading());
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await _controller!.initialize();
      _controller!.play();
      _controller!.setLooping(true);
      logger.d('Video loaded: $url');
      emit(VideoLoaded(_controller!));
    } catch (e) {
      logger.e('Failed to load video: $e');
      emit(VideoLoadError('Failed to load video: $e'));
    }
  }

  @override
  Future<void> close() {
    _controller?.pause();
    _controller?.dispose();
    logger.d("Video is closed");
    return super.close();
  }
}
