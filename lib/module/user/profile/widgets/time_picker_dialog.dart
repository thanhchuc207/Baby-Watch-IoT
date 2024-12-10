// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/locators/locator.dart';
import '../../../../core/utils/logger.dart';
import '../bloc/profile_cubit.dart';
import '../cubit/time_picker_cubit.dart';

class TimePickerDialog extends StatelessWidget {
  final List<int> hourOptions = [0, 1];
  final List<int> minuteOptions = List.generate(12, (index) => index * 5);

  late final FixedExtentScrollController hourScrollController;
  late final FixedExtentScrollController minuteScrollController;

  TimePickerDialog({super.key}) {
    final initialState = authRepository.getUser()!.schedule == 60 ? 1 : 0;
    final initialMinute = authRepository.getUser()!.schedule == 60
        ? 0
        : authRepository.getUser()!.schedule;

    // Sử dụng giá trị ban đầu từ Cubit để thiết lập vị trí cho scrollController
    hourScrollController = FixedExtentScrollController(
        initialItem: hourOptions.indexOf(initialState));
    minuteScrollController = FixedExtentScrollController(
        initialItem: minuteOptions.indexOf(initialMinute));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thiết lập thời gian',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Giờ
                Column(
                  children: [
                    Text(
                      'Giờ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 100,
                      width: 60,
                      child: BlocBuilder<TimePickerCubit, TimePickerState>(
                        builder: (context, state) {
                          return CupertinoPicker(
                            scrollController: hourScrollController,
                            itemExtent: 50,
                            onSelectedItemChanged: (index) {
                              int selectedHour = hourOptions[index];
                              context
                                  .read<TimePickerCubit>()
                                  .updateHour(selectedHour);

                              // Nếu giờ là 1, đặt phút về 0 và cuộn picker phút về 0
                              if (selectedHour == 1) {
                                context.read<TimePickerCubit>().updateMinute(0);
                                minuteScrollController.jumpToItem(0);
                              }
                            },
                            children: hourOptions
                                .map((hour) => Center(
                                      child: Text(
                                        hour.toString().padLeft(2, '0'),
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Separator
                Center(
                  child: Text(
                    ':',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                // Phút
                Column(
                  children: [
                    Text(
                      'Phút',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 100,
                      width: 60,
                      child: BlocBuilder<TimePickerCubit, TimePickerState>(
                        builder: (context, state) {
                          bool isMinutePickerEnabled = state.selectedHour == 0;
                          return IgnorePointer(
                            ignoring: !isMinutePickerEnabled,
                            child: Opacity(
                              opacity: isMinutePickerEnabled ? 1.0 : 0.3,
                              child: CupertinoPicker(
                                scrollController: minuteScrollController,
                                itemExtent: 50,
                                onSelectedItemChanged: (index) {
                                  if (isMinutePickerEnabled) {
                                    context
                                        .read<TimePickerCubit>()
                                        .updateMinute(minuteOptions[index]);
                                  }
                                },
                                children: minuteOptions
                                    .map((minute) => Center(
                                          child: Text(
                                            minute.toString().padLeft(2, '0'),
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // OK Button
            Align(
              alignment: Alignment.bottomRight,
              child: BlocBuilder<TimePickerCubit, TimePickerState>(
                builder: (context, state) {
                  bool isButtonEnabled =
                      !(state.selectedHour == 0 && state.selectedMinute == 0);
                  return TextButton(
                    onPressed: isButtonEnabled
                        ? () {
                            final state = context.read<TimePickerCubit>().state;
                            logger.i(
                                'OK button pressed, selected time: ${state.selectedHour} : ${state.selectedMinute}');
                            Navigator.of(context).pop({
                              'hour': state.selectedHour,
                              'minute': state.selectedMinute,
                            });
                          }
                        : null,
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                        color: isButtonEnabled
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey, // Make text grey if disabled
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the dialog
void showTimePickerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider(
        create: (_) => TimePickerCubit(),
        child: TimePickerDialog(),
      );
    },
  ).then((result) {
    if (result != null) {
      int time = result['hour'] * 60 + result['minute'];
      logger.i('Selected time: $time minutes');
      context.read<ProfileCubit>().updateTimeNotification(time);
    }
  });
}
