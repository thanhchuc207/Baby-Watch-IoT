part of 'splash_bloc.dart';

@freezed
class SplashEvent with _$SplashEvent {
  const factory SplashEvent.started(BuildContext context) = _Started;
  const factory SplashEvent.moveToApp(BuildContext context, String route) =
      _MoveToApp;
  const factory SplashEvent.timerTicked(int duration) = _TimerTicked;
}
