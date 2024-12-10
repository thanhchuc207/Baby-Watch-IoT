import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../core/utils/logger.dart';
import '../model/notification_model.dart';

@singleton
class NotificationRepository {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  Future<void> addNotification(
      String userId, String content, DateTime time) async {
    // Tạo key mới cho mỗi thông báo
    String notiKey = databaseRef.child('notification/$userId').push().key!;

    // Dữ liệu thông báo cần thêm
    final notificationData = {
      "createAt": time.toIso8601String(),
      "content": content,
    };

    // Thêm thông báo vào đường dẫn: notification/userId/notiKey
    await databaseRef
        .child('notification/$userId/$notiKey')
        .set(notificationData);
  }

  Future<void> generateFakeNotifications() async {
    final List<String> contents = [
      "Đói bụng",
      "Buồn ngủ",
      "Mệt mỏi",
      "Nằm nghiêng quá lâu",
      "Nằm sấp quá lâu",
    ];

    final Random random = Random();

    for (int i = 0; i < 50; i++) {
      // Chọn ngẫu nhiên nội dung
      String content = contents[random.nextInt(contents.length)];

      // Random ngày và giờ trong khoảng 7 ngày vừa qua
      DateTime now = DateTime.now();
      int daysAgo = random.nextInt(7); // Từ 0 đến 6 ngày trước
      int hour = random.nextInt(24); // Từ 0 đến 23 giờ
      int minute = random.nextInt(60); // Từ 0 đến 59 phút

      DateTime createdAt =
          DateTime(now.year, now.month, now.day - daysAgo, hour, minute);

      addNotification('pbl6_01', content, createdAt);
    }
  }

  Future<List<NotificationModel>> getNotificationsByDate(
      String userId, DateTime date) async {
    List<NotificationModel> notifications = [];

    try {
      // Định dạng ngày để dễ so sánh
      final DateFormat dateFormat = DateFormat("yyyy-MM-dd");

      // Lấy dữ liệu thông báo của người dùng
      final snapshot = await databaseRef.child('notification/$userId').get();

      if (snapshot.exists) {
        // Duyệt qua các thông báo và lọc theo ngày
        snapshot.children.forEach((child) {
          final data = child.value as Map<dynamic, dynamic>;
          final createdAt = DateTime.parse(data['createAt']);
          final formattedCreatedAt = dateFormat.format(createdAt);
          final formattedDate = dateFormat.format(date);

          // Kiểm tra nếu thông báo thuộc ngày cần tìm
          if (formattedCreatedAt == formattedDate) {
            notifications.add(
                NotificationModel.fromJson(Map<String, dynamic>.from(data)));
          }
        });
      }
    } catch (e) {
      logger.e("Error fetching notifications: $e");
    }

    return notifications;
  }
}
