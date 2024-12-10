import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/model/user_model.dart';
import '../local/storage.dart';

@Singleton()
class AuthRepository {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  Future<UserModel?> signIn(String systemCode, String phoneNumber) async {
    // Step 1: Check if the system code exists in 'accounts'
    final accountRef =
        FirebaseDatabase.instance.ref().child('accounts/$systemCode');
    final accountSnapshot =
        await accountRef.orderByChild('phone').equalTo(phoneNumber).get();

    if (accountSnapshot.exists) {
      // Retrieve the first matching account entry
      final userData = Map<String, dynamic>.from(
        (accountSnapshot.value as Map<dynamic, dynamic>).values.first,
      );

      // Create UserModel from the retrieved data
      final user = UserModel.fromJson(userData);
      return user;
    }
    return null; // Trả về null nếu không tìm thấy
  }

  Future<void> saveUserInfo(UserModel user) async {
    await Storage.setUser(user);
  }

  UserModel? getUser() => Storage.user;

  // Hàm đăng xuất
  Future<void> logout() async {
    // Xóa thông tin người dùng và token khi đăng xuất
    await Storage.clear();
  }
}
