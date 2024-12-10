import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/locators/locator.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/local/storage.dart';
import '../../../../data/model/user_model.dart';

part 'auth_state.dart';

@Singleton()
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void signIn(String systemCode, String phoneNumber) async {
    emit(AuthLoading());
    try {
      // Sử dụng phương thức signIn từ AuthRepository để lấy UserModel
      final user = await authRepository.signIn(systemCode, phoneNumber);

      if (user != null) {
        // Lưu thông tin người dùng vào bộ nhớ cục bộ
        await authRepository.saveUserInfo(user);
        _updateProfile((user) => user.copyWith(deviceToken: Storage.deviceId));
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Không tìm thấy người dùng.'));
      }
    } catch (e) {
      logger.e('Error signing in: $e');
      emit(AuthError('Có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }

  // Hàm cập nhật thông tin người dùng với hàm tạo UserModel cập nhật tùy chỉnh
  void _updateProfile(UserModel Function(UserModel) updateUser) async {
    try {
      final user = authRepository.getUser();
      if (user == null) {
        return;
      }

      final updatedUser = updateUser(user);
      await userRepository.updateAccountInfo(updatedUser);
    } catch (e) {
      logger.e('Error updating profile: $e');
    }
  }

  void signOut() async {
    _updateProfile((user) => user.copyWith(deviceToken: ''));
    await authRepository.logout();
    emit(AuthInitial());
  }
}
