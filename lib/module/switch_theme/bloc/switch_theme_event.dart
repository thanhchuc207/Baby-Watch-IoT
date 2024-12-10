part of 'switch_theme_bloc.dart';

@freezed
class SwitchThemeEvent with _$SwitchThemeEvent {
  const factory SwitchThemeEvent.toggleTheme() =
      _ToggleTheme; // Sự kiện chuyển đổi theme
}
