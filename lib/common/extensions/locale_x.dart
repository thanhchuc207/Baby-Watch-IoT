import 'dart:ui';
import '../../../generated/l10n.dart';

extension LocaleX on Locale {
  // Trả về tên ngôn ngữ (tiếng Anh hoặc tiếng Việt)
  String get languageName {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      default:
        return 'Unknown'; // Mặc định nếu không phải en hoặc vi
    }
  }

  // Trả về mã ngôn ngữ để sử dụng với API (chỉ 'en' và 'vi')
  String get apiKey {
    switch (languageCode) {
      case 'en':
        return 'en';
      case 'vi':
        return 'vi';
      default:
        return 'en'; // Mặc định là tiếng Anh nếu không nhận diện được
    }
  }

  // Lấy ra languageCode và scriptCode, kết hợp thành dạng languageCode_scriptCode hoặc chỉ languageCode nếu scriptCode = null
  String get fullLanguageCode =>
      [languageCode, scriptCode].where((element) => element != null).join('_');

  // So sánh hai Locale, kiểm tra xem chúng có giống nhau không
  bool isEqualTo(Locale compare) {
    if (this == compare) {
      return true;
    }
    if (scriptCode?.isNotEmpty == true && scriptCode == compare.scriptCode) {
      return true;
    }
    if ((scriptCode?.isEmpty == true || compare.scriptCode?.isEmpty == true) &&
        countryCode?.isNotEmpty == true &&
        countryCode == compare.countryCode) {
      return true;
    }
    return false;
  }

  // Lấy danh sách các Locale được hỗ trợ (tiếng Anh và tiếng Việt)
  static List<Locale> get supportedLocales =>
      List<Locale>.from(S.delegate.supportedLocales)
        ..sort((l, r) {
          return l.languageCode.compareTo(r.languageCode);
        });

  // Định nghĩa ngôn ngữ mặc định nếu không có Locale được chọn (fallback là tiếng Việt)
  static Locale get fallbackLocale => const Locale('vi');
}

extension StringLocale on String {
  // Chuyển đổi chuỗi thành Locale (chỉ hỗ trợ 'en' và 'vi')
  Locale get toLocale {
    final components = split('_');
    if (components.isNotEmpty) {
      return Locale(components[0]);
    } else {
      return LocaleX.fallbackLocale;
    }
  }
}
