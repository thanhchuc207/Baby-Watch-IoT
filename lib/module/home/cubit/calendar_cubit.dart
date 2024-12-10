import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

part 'calendar_state.dart';

@lazySingleton
class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(
          CalendarState(
            selectedDate: DateTime.now(),
            today: DateTime.now(),
          ),
        );

  // Hàm để cập nhật ngày được chọn
  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }
}
