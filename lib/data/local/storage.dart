// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/logger.dart';
import '../model/user_model.dart';

class _Keys {
  //Lớp _Keys chứa các hằng số đại diện cho các khóa (keys)
  //được sử dụng để lưu trữ và truy xuất giá trị từ SharedPreferences và FlutterSecureStorage
  static const lang = 'lang';
  static const user = 'user';
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const deviceId = 'device_id';
  static const pushToken = 'push_token';
  static const rememberMe = 'remember_me';
  static const themeMode = 'theme_mode';
}

//quản lý việc lưu trữ dữ liệu cục bộ
//sử dụng SharedPreferences và FlutterSecureStorage
class Storage {
  static late final SharedPreferences _prefs;
  //Gói mở rộng của SharedPreferences
  //cung cấp khả năng lắng nghe các thay đổi từ SharedPreferences bằng Stream
  static late final RxSharedPreferences _rxPrefs;
  // Thư viện để lưu trữ dữ liệu bảo mật (như token)
  //sử dụng các cơ chế mã hóa.
  static const _storage = FlutterSecureStorage();

  // khởi tạo các đối tượng SharedPreferences và RxSharedPreferences
  static setup() async {
    _prefs = await SharedPreferences.getInstance();

    /// A shared preference wrapper providing [Stream] for listening updates
    /// from shared preference by key
    //RxSharedPreferences nhận vào hai tham số:
    //- đối tượng SharedPreferences
    //- đối tượng RxSharedPreferencesDefaultLogger
    //kReleaseMode là một hằng số chỉ ra ứng dụng đang chạy ở chế độ phát hành hay không
    _rxPrefs = RxSharedPreferences(
      _prefs,
      // disable logging when running in release mode.
      //Nếu ứng dụng chạy ở chế độ phát hành (release mode), tham số này sẽ là null, giúp tắt logging khi chạy ứng dụng ở chế độ phát hành để giảm bớt các log không cần thiết.
      kReleaseMode ? null : const RxSharedPreferencesDefaultLogger(),
    );
  }

  //phương thức tổng quát có thể dùng để get giá trị của SharedPreferce
  //ko phụ thuộc vào kdl (thông qua key kiểu string)
  static T? _get<T>(String key) => _prefs.get(key) as T?;

  /// set value to shared preference by [key].
  /// If you want the updated value to be notified for stream subscriptions
  /// created by [RxSharedPreferences], please set [notify] as `true`

  //phương thức tổng quát có thể dùng để set giá trị của SharedPreferce
  //ko phụ thuộc vào kdl (thông qua key kiểu string)
  //nhận vào một key kiểu String, một giá trị val kiểu T, và một tùy chọn notify kiểu bool
  static Future<void> _set<T>(String key, T? val, {bool notify = false}) {
    if (val is bool) {
      return notify ? _rxPrefs.setBool(key, val) : _prefs.setBool(key, val);
    }
    if (val is double) {
      return notify ? _rxPrefs.setDouble(key, val) : _prefs.setDouble(key, val);
    }
    if (val is int) {
      return notify ? _rxPrefs.setInt(key, val) : _prefs.setInt(key, val);
    }
    if (val is String) {
      return notify ? _rxPrefs.setString(key, val) : _prefs.setString(key, val);
    }
    if (val is List<String>) {
      return notify
          ? _rxPrefs.setStringList(key, val)
          : _prefs.setStringList(key, val);
    }
    throw Exception('Type not supported!');
  }

  static Future<String?> _getSecure(String key) => _storage.read(key: key);

  static Future<void> _setSecure(String key, String? val) =>
      _storage.write(key: key, value: val);

  static String? get lang => _get(_Keys.lang);

  static Future setLang(String? val) => _set(_Keys.lang, val);

  static String get deviceId {
    String? deviceId = _get(_Keys.deviceId);
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      setDeviceId(deviceId);
    }
    return deviceId;
  }

  static Future setDeviceId(String? val) => _set(_Keys.deviceId, val);

  static String? get pushToken => _get(_Keys.pushToken);

  static Future setPushToken(String? val) => _set(_Keys.pushToken, val);

  // Lưu thông tin người dùng vào SharedPreferences
  static Future<void> setUser(UserModel user) async {
    final jsonUser = jsonEncode(user.toJson()); // Chuyển UserModel thành JSON
    await _set(_Keys.user, jsonUser); // Lưu JSON vào SharedPreferences
  }

  // Truy xuất thông tin người dùng từ SharedPreferences
  static UserModel? get user {
    final jsonString =
        _get<String>(_Keys.user); // Lấy JSON từ SharedPreferences
    if (jsonString == null) return null;
    try {
      return UserModel.fromJson(
          jsonDecode(jsonString)); // Chuyển JSON thành UserModel
    } catch (e) {
      logger.e('Error parsing user: $e');
      return null;
    }
  }

  // Lưu accessToken vào FlutterSecureStorage
  static Future<void> setAccessToken(String? accessToken) async {
    await _setSecure(_Keys.accessToken, accessToken); // Lưu accessToken
  }

  // Truy xuất accessToken từ FlutterSecureStorage
  static Future<String?> getAccessToken() async {
    return _getSecure(_Keys.accessToken); // Lấy accessToken
  }

  // Lưu refreshToken vào FlutterSecureStorage
  static Future<void> setRefreshToken(String? refreshToken) async {
    await _setSecure(_Keys.refreshToken, refreshToken); // Lưu refreshToken
  }

  // Truy xuất refreshToken từ FlutterSecureStorage
  static Future<String?> getRefreshToken() async {
    return _getSecure(_Keys.refreshToken); // Lấy refreshToken
  }

  // Lưu rememberMe vào SharedPreferences
  static Future<void> setRememberMe(bool rememberMe) async {
    await _set(_Keys.rememberMe, rememberMe); // Lưu rememberMe
  }

  // Truy xuất rememberMe từ SharedPreferences
  static bool get rememberMe => _get<bool>(_Keys.rememberMe) ?? false;

  // Phương thức xóa toàn bộ dữ liệu khi đăng xuất
  static Future<void> clear() async {
    // Xóa thông tin người dùng
    await _prefs.remove(_Keys.user);

    // Xóa accessToken và refreshToken
    await _storage.delete(key: _Keys.accessToken);
    await _storage.delete(key: _Keys.refreshToken);
  }

  // Lưu themeMode vào SharedPreferences
  static Future<void> setThemeMode(int themeMode) async {
    await _set(_Keys.themeMode, themeMode); // Lưu themeMode
  }

  // Truy xuất themeMode từ SharedPreferences
  static int get themeMode => _get<int>(_Keys.themeMode) ?? 0;
}
