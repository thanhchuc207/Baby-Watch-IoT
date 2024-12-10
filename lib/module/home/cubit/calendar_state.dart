part of 'calendar_cubit.dart';

class CalendarState {
  final DateTime selectedDate;
  final DateTime today;

  CalendarState({
    required this.selectedDate,
    required this.today,
  });

  // Copy method để tạo một trạng thái mới với giá trị selectedDate mới
  CalendarState copyWith({DateTime? selectedDate}) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      today: this.today,
    );
  }
}
