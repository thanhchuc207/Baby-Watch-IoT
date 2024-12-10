import 'package:freezed_annotation/freezed_annotation.dart';

import '../remote/services/home/entities/notification.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel implements Notification {
  const factory NotificationModel({
    @Default('') String content,
    DateTime? createAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
