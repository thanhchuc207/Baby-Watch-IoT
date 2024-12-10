// time_picker_state.dart
part of 'time_picker_cubit.dart';

@freezed
class TimePickerState with _$TimePickerState {
  const factory TimePickerState.initial({
    required int selectedHour,
    required int selectedMinute,
  }) = _Initial;
}
