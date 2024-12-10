// time_picker_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/locators/locator.dart';
import '../../../../core/utils/logger.dart';

part 'time_picker_state.dart';
part 'time_picker_cubit.freezed.dart';

class TimePickerCubit extends Cubit<TimePickerState> {
  TimePickerCubit()
      : super(TimePickerState.initial(
          selectedHour: authRepository.getUser()!.schedule == 60 ? 1 : 0,
          selectedMinute: authRepository.getUser()!.schedule == 60
              ? 0
              : authRepository.getUser()!.schedule,
        ));

  // Cập nhật giờ
  void updateHour(int hour) {
    logger.i("Selected hour: $hour");
    if (hour == 1) {
      // Nếu giờ là 1, đặt phút về 0 trước khi emit
      emit(state.copyWith(selectedHour: hour, selectedMinute: 0));
    } else {
      emit(state.copyWith(selectedHour: hour));
    }
  }

  // Cập nhật phút
  void updateMinute(int minute) {
    logger.i("Selected minute: $minute");
    emit(state.copyWith(selectedMinute: minute));
  }
}
