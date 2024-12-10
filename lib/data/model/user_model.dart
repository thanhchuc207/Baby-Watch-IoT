import 'package:freezed_annotation/freezed_annotation.dart';

import '../remote/services/auth/entities/user.dart';

part 'user_model.g.dart';
part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel implements User {
  const factory UserModel({
    @Default('') String code,
    @Default('') String phone,
    @Default('') String name,
    @Default('') String deviceToken,
    @Default(true) bool enableNotification,
    @Default(30) int schedule,
    DateTime? lastNotificationAt, // Cho phép null
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
