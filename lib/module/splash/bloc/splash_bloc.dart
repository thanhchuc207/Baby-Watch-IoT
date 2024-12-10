// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/app/route_path.dart';
import '../../../core/locators/locator.dart';
import '../../../core/utils/logger.dart';
import '../../auth/sign_in/cubit/auth_cubit.dart';

part 'splash_event.dart';
part 'splash_state.dart';
part 'splash_bloc.freezed.dart';

@singleton
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  StreamSubscription<int>? _tickerSubscription;
  static const int _splashDuration = 3; // Set splash duration to 3 seconds
  Timer? _timer;

  SplashBloc() : super(_Initial()) {
    on<_Started>((event, emit) async {
      final userInfo = await authRepository.getUser();
      if (userInfo != null) {
        logger.i('User info fetched successfully');
        authCubit.emit(AuthSuccess(userInfo));
        _startSplashTimer(event.context, Routers.main);
      } else {
        logger.i('User info is null');
        authCubit.emit(AuthInitial());
        _startSplashTimer(event.context, Routers.signIn);
      }
    });
    on<_MoveToApp>((event, emit) async {
      event.context.router.replaceNamed(event.route);
    });
    on<_TimerTicked>((event, emit) async {
      emit(_RunInProgress(event.duration));
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    _timer?.cancel();
    return super.close();
  }

  void _startSplashTimer(BuildContext context, String route) {
    // Start the timer for splash screen
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int remaining = _splashDuration - timer.tick;
      if (remaining > 0) {
        add(_TimerTicked(remaining));
      } else {
        add(_MoveToApp(context, route));
        _timer?.cancel();
      }
    });
  }
}
