part of 'form_bloc.dart';

@freezed
class FormState with _$FormState {
  const factory FormState.initial() = _Initial;
  const factory FormState.error({
    String? usernameError,
    String? codeSystemError,
    String? phoneError,
    String? otherError,
  }) = _Error;
}
