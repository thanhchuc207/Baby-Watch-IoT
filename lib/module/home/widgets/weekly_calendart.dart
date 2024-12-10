import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/calendar_cubit.dart';
import '../cubit/home_cubit.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    List<DateTime> weekDates = List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );

    return BlocProvider(
      create: (_) => CalendarCubit(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDates.map((date) {
            return BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {
                bool isToday = date.day == state.today.day &&
                    date.month == state.today.month &&
                    date.year == state.today.year;
                bool isSelected = date.day == state.selectedDate.day &&
                    date.month == state.selectedDate.month &&
                    date.year == state.selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    context.read<CalendarCubit>().selectDate(date);
                    context.read<HomeCubit>().updateSelectedDate(date);
                  },
                  child: Column(
                    children: [
                      Text(
                        _getDayOfWeek(date),
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 50, // Đặt kích thước cố định
                        height: 50, // Đặt kích thước cố định
                        decoration: (isToday && isSelected)
                            ? BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              )
                            : isToday
                                ? BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  )
                                : isSelected
                                    ? BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        shape: BoxShape.circle,
                                      )
                                    : null,
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getDayOfWeek(DateTime date) {
    List<String> daysOfWeek = [
      'T2',
      'T3',
      'T4',
      'T5',
      'T6',
      'T7',
      'CN',
    ];
    int weekdayIndex = date.weekday % 7; // Điều chỉnh để bắt đầu từ "Thứ 2"
    if (date == DateTime.now()) {
      return 'Hôm nay'; // Hiển thị "Hôm nay" cho ngày hiện tại
    }
    return daysOfWeek[weekdayIndex];
  }
}
