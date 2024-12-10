// write a extension method for String class to valid email
import 'dart:convert';
import 'package:intl/intl.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  bool isValidUsername() {
    return RegExp(r'^[a-zA-Z0-9._%+-]{3,}$').hasMatch(this);
  }

  bool passwordHasAtLeast8Characters() {
    return length >= 8;
  }

  bool passwordHasAtLeast1Uppercase() {
    return RegExp(r'[A-Z]').hasMatch(this);
  }

  bool passwordHasAtLeast1Lowercase() {
    return RegExp(r'[a-z]').hasMatch(this);
  }

  bool passwordHasAtLeast1Number() {
    return RegExp(r'[0-9]').hasMatch(this);
  }

  bool passwordHasAtLeast1SpecialCharacter() {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(this);
  }

  DateTime getExpiryDateFromToken() {
    final parts = split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));
    final map = json.decode(resp);
    final exp = map['exp'] * 1000;
    return DateTime.fromMillisecondsSinceEpoch(exp);
  }

  bool isTokenExpired() {
    final expiryDate = getExpiryDateFromToken();
    return expiryDate.isBefore(DateTime.now());
  }

  bool isPhoneNumber() {
    // Kiểm tra chuỗi có đúng 10 chữ số
    return RegExp(r'^\d{10}$').hasMatch(this);
  }

  String? getErrorPasswordMessage() {
    if (isEmpty) {
      return 'Password cannot be empty';
    } else if (!passwordHasAtLeast8Characters()) {
      return 'Password must be at least 8 characters long';
    } else if (!passwordHasAtLeast1Uppercase()) {
      return 'Password must have at least 1 uppercase letter';
    } else if (!passwordHasAtLeast1Lowercase()) {
      return 'Password must have at least 1 lowercase letter';
    } else if (!passwordHasAtLeast1Number()) {
      return 'Password must have at least 1 number';
    } else if (!passwordHasAtLeast1SpecialCharacter()) {
      return 'Password must have at least 1 special character';
    }
    return null;
  }

  String? getErrorEmailMessage() {
    if (isEmpty) {
      return 'Email cannot be empty';
    } else if (!isValidEmail()) {
      return 'Invalid email';
    }
    return null;
  }

  String? getErrorUsernameMessage() {
    if (isEmpty) {
      return 'Username cannot be empty';
    } else if (!isValidUsername()) {
      return 'Invalid username';
    }
    return null;
  }

  String? getErrorPhoneNumberMessage() {
    if (isEmpty) {
      return 'Phone number cannot be empty';
    } else if (!isPhoneNumber()) {
      return 'Invalid phone number';
    }
    return null;
  }

  String? getErrorCodeSystemMessage() {
    if (isEmpty) {
      return 'Code system cannot be empty';
    }
    return null;
  }
}

extension DateTimeFormatting on DateTime {
  String toCustomFormat() {
    final DateFormat dateFormat = DateFormat("dd 'Th'MM HH:mm");
    return dateFormat.format(this.toLocal());
  }
}
