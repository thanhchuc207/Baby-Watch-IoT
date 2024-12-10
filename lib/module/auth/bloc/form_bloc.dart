import 'dart:async';

import 'package:iot_baby_watch/common/extensions/string_x.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'form_event.dart';
part 'form_state.dart';
part 'form_bloc.freezed.dart';

@LazySingleton()
class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc() : super(_Initial()) {
    on<_UsernameChanged>(_onUsernameChanged);
    on<_PhoneChanged>(_onPhoneChanged);
    on<_CodeSystemChanged>(_onCodeSystemChanged);
  }

  FutureOr<void> _onUsernameChanged(
      _UsernameChanged event, Emitter<FormState> emit) {
    final currentState = state;
    final usernameError = event.username.getErrorUsernameMessage();

    if (currentState is _Error) {
      emit(currentState.copyWith(usernameError: usernameError));
    } else {
      emit(FormState.error(usernameError: usernameError));
    }
  }

  FutureOr<void> _onPhoneChanged(_PhoneChanged event, Emitter<FormState> emit) {
    final currentState = state;
    String? phoneError = event.phone.getErrorPhoneNumberMessage();

    if (currentState is _Error) {
      emit(currentState.copyWith(phoneError: phoneError));
    } else {
      emit(FormState.error(phoneError: phoneError));
    }
  }

  FutureOr<void> _onCodeSystemChanged(
      _CodeSystemChanged event, Emitter<FormState> emit) {
    final currentState = state;
    String? codeSystemError = event.codeSystem.getErrorCodeSystemMessage();

    if (currentState is _Error) {
      emit(currentState.copyWith(codeSystemError: codeSystemError));
    } else {
      emit(FormState.error(codeSystemError: codeSystemError));
    }
  }
}
