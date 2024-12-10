// home_state.dart
part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial({
    required DateTime selectedDate,
  }) = _Initial;

  const factory HomeState.loading({
    required DateTime selectedDate,
  }) = _Loading;

  const factory HomeState.loaded({
    required DateTime selectedDate,
    required List<NotificationModel> notifications,
  }) = _Loaded;

  const factory HomeState.error({
    required DateTime selectedDate,
    required String errorMessage,
  }) = _Error;
}
