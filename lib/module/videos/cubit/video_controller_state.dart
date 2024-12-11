part of 'video_controller_cubit.dart';

@immutable
abstract class VideoControllerState extends Equatable {
  const VideoControllerState();

  @override
  List<Object> get props => [];
}

class VideoLoaded extends VideoControllerState {
  final VideoPlayerController controller;

  const VideoLoaded(this.controller);

  @override
  List<Object> get props => [controller];
}

class VideoLoadError extends VideoControllerState {
  final String message;

  const VideoLoadError(this.message);

  @override
  List<Object> get props => [message];
}

class VideoLoading extends VideoControllerState {
  const VideoLoading();

  @override
  List<Object> get props => [];
}
