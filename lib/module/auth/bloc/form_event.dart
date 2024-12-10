part of 'form_bloc.dart';

@freezed
class FormEvent with _$FormEvent {
  const factory FormEvent.codeSystemChanged(String codeSystem) =
      _CodeSystemChanged;
  const factory FormEvent.usernameChanged(String username) = _UsernameChanged;
  const factory FormEvent.phoneChanged(String phone) = _PhoneChanged;
}
