// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a vi locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'vi';

  static String m0(name) => "Xin chào, ${name}";

  static String m1(version) => "Phiên bản ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("Giới thiệu"),
        "cancel": MessageLookupByLibrary.simpleMessage("Hủy"),
        "confirm": MessageLookupByLibrary.simpleMessage("Xác nhận"),
        "counter": MessageLookupByLibrary.simpleMessage("Bộ đếm"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "error": MessageLookupByLibrary.simpleMessage("Lỗi"),
        "error_internal_server":
            MessageLookupByLibrary.simpleMessage("Lỗi máy chủ nội bộ"),
        "error_invalid_email":
            MessageLookupByLibrary.simpleMessage("Email không hợp lệ"),
        "error_invalid_password": MessageLookupByLibrary.simpleMessage(
            "Mật khẩu của bạn phải có ít nhất 8 ký tự bao gồm chữ cái thường, chữ cái hoa và số"),
        "error_network": MessageLookupByLibrary.simpleMessage("Lỗi mạng!"),
        "error_unauthorized":
            MessageLookupByLibrary.simpleMessage("Không có quyền truy cập!"),
        "error_unexpected":
            MessageLookupByLibrary.simpleMessage("Đã xảy ra lỗi!"),
        "hello": m0,
        "language": MessageLookupByLibrary.simpleMessage("Ngôn ngữ"),
        "login": MessageLookupByLibrary.simpleMessage("Đăng nhập"),
        "logout": MessageLookupByLibrary.simpleMessage("Đăng xuất"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "password": MessageLookupByLibrary.simpleMessage("Mật khẩu"),
        "privacy_policies":
            MessageLookupByLibrary.simpleMessage("Chính sách bảo mật"),
        "settings": MessageLookupByLibrary.simpleMessage("Cài đặt"),
        "terms_conditions":
            MessageLookupByLibrary.simpleMessage("Điều khoản & Điều kiện"),
        "version_x": m1
      };
}
