import 'package:flutter/material.dart';

enum AuthProvider {
  // ignore: constant_identifier_names
  Email,
  // ignore: constant_identifier_names
  Google,
  // ignore: constant_identifier_names
  Facebook,
  // ignore: constant_identifier_names
  GitHub,
}

extension AuthProviderExtension on AuthProvider {
  String get name {
    switch (this) {
      case AuthProvider.Email:
        return "Email";
      case AuthProvider.Google:
        return "Google";
      case AuthProvider.Facebook:
        return "Facebook";
      case AuthProvider.GitHub:
        return "GitHub";
      default:
        return "";
    }
  }
}

enum OtpType {
  // ignore: constant_identifier_names
  ForgotPassword,
  // ignore: constant_identifier_names
  ConfirmDeleteAccount,
}

extension OtpTypeExtension on OtpType {
  int get value {
    switch (this) {
      case OtpType.ForgotPassword:
        return 1;
      case OtpType.ConfirmDeleteAccount:
        return 2;
      default:
        return 1;
    }
  }
}

enum SortOrder { ascending, descending }

enum NotificationType {
  hungry,
  sleepy,
  tired,
  lyingTooLong,
  lyingFaceDownTooLong,
  defaultType,
}

extension NotificationTypeExtension on NotificationType {
  Icon get icon {
    switch (this) {
      case NotificationType.hungry:
        return Icon(Icons.local_drink,
            color: Colors.blue, size: 32); // Biểu tượng chai sữa màu xanh
      case NotificationType.sleepy:
        return Icon(Icons.bedtime,
            color: Colors.purple, size: 32); // Biểu tượng buồn ngủ màu tím
      case NotificationType.tired:
        return Icon(Icons.sentiment_dissatisfied,
            color: Colors.orange, size: 32); // Biểu tượng mệt mỏi màu cam
      case NotificationType.lyingTooLong:
        return Icon(Icons.warning,
            color: Colors.red, size: 32); // Biểu tượng cảnh báo màu đỏ
      case NotificationType.lyingFaceDownTooLong:
        return Icon(Icons.warning,
            color: Colors.deepOrange, size: 32); // Biểu tượng cảnh báo màu đỏ
      default:
        return Icon(Icons.notifications,
            color: Colors.grey, size: 32); // Biểu tượng mặc định màu xám
    }
  }

  static NotificationType fromContent(String content) {
    switch (content) {
      case "Đói bụng":
        return NotificationType.hungry;
      case "Buồn ngủ":
        return NotificationType.sleepy;
      case "Mệt mỏi":
        return NotificationType.tired;
      case "Nằm nghiêng quá lâu":
        return NotificationType.lyingTooLong;
      case "Nằm sấp quá lâu":
        return NotificationType.lyingFaceDownTooLong;
      default:
        return NotificationType.defaultType;
    }
  }
}

extension NotificationTypeDescription on NotificationType {
  String getString() {
    switch (this) {
      case NotificationType.hungry:
        return "Đói bụng";
      case NotificationType.sleepy:
        return "Buồn ngủ";
      case NotificationType.tired:
        return "Mệt mỏi";
      case NotificationType.lyingTooLong:
        return "Nằm nghiêng quá lâu";
      case NotificationType.lyingFaceDownTooLong:
        return "Nằm sấp quá lâu";
      default:
        return "Thông báo khác";
    }
  }
}
