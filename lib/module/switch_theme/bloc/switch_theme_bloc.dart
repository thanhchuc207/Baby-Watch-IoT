import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../data/local/storage.dart';

part 'switch_theme_event.dart';
part 'switch_theme_state.dart';
part 'switch_theme_bloc.freezed.dart';

@singleton
class SwitchThemeBloc extends Bloc<SwitchThemeEvent, SwitchThemeState> {
  // Khởi tạo với trạng thái ban đầu là hệ thống hoặc một theme mặc định
  SwitchThemeBloc()
      : super(
          Storage.themeMode == 0
              ? SwitchThemeState(themeMode: ThemeMode.dark)
              : SwitchThemeState(themeMode: ThemeMode.light),
        ) {
    on<_ToggleTheme>(_onToggleTheme);
  }

  void _onToggleTheme(_ToggleTheme event, Emitter<SwitchThemeState> emit) {
    // Chuyển đổi giữa light và dark
    if (state.themeMode == ThemeMode.light) {
      Storage.setThemeMode(0);
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else {
      Storage.setThemeMode(1);
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }
}
