part of 'audio_cubit.dart';

@freezed
class AudioState with _$AudioState {
  const factory AudioState.initial() = _AudioStateInitial;
  const factory AudioState.playing(String url) = _AudioStatePlaying;
  const factory AudioState.stopped() = _AudioStateStopped;
  const factory AudioState.error(String message) = _AudioStateError;
}
