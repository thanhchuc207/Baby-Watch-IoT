part of 'splash_bloc.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = _Initial;
  const factory SplashState.runInProgress(int duration) = _RunInProgress;
  const factory SplashState.completed() = _Completed;
  const factory SplashState.error(String message) = _Error;
  const factory SplashState.loading() = _Loading;
}
