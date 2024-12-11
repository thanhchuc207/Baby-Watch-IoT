part of 'media_cubit.dart';

@freezed
class MediaState with _$MediaState {
  const factory MediaState.initial() = _Initial;
  const factory MediaState.loading({required bool loading}) = _Loading;
  const factory MediaState.loaded({required String videoUrl}) = _Loaded;
}
