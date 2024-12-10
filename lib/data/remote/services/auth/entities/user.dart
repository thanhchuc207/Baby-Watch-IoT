abstract class User {
  String get code;
  String get phone;
  String get name;
  String get deviceToken;
  bool get enableNotification;
  int get schedule;
  DateTime? get lastNotificationAt;
}
