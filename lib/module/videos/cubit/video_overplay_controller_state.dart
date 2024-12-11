part of 'video_overplay_controller_cubit.dart';

@immutable
abstract class VideoOverplayControllerState extends Equatable {
  const VideoOverplayControllerState();
  @override
  List<Object> get props => [];
}

class VideoOverplayControllerWhenLoading extends VideoOverplayControllerState {
  final bool showControls;
  const VideoOverplayControllerWhenLoading([this.showControls = false]);

  @override
  List<Object> get props => [showControls];

  VideoOverplayControllerWhenLoading copyWith({
    bool? showControls,
  }) {
    return VideoOverplayControllerWhenLoading(
      showControls ?? this.showControls,
    );
  }
}

class VideoOverplayControllerWhenPause extends VideoOverplayControllerState {
  final bool showControls;
  const VideoOverplayControllerWhenPause([this.showControls = true]);

  @override
  List<Object> get props => [showControls];

  VideoOverplayControllerWhenPause copyWith({
    bool? showControls,
  }) {
    return VideoOverplayControllerWhenPause(
      showControls ?? this.showControls,
    );
  }
}
