import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/locators/locator.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/model/user_model.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

@singleton
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(_Initial());

  bool get enableNotification =>
      authRepository.getUser()?.enableNotification ?? false;

// Cập nhật thời gian thông báo
  void updateTimeNotification(int minutes) {
    _updateProfile((user) => user.copyWith(schedule: minutes));
  }

  // Cập nhật trạng thái bật/tắt thông báo
  void updateEnableNotification(bool value) {
    _updateProfile((user) => user.copyWith(enableNotification: value));
  }

  // Hàm cập nhật thông tin người dùng với hàm tạo UserModel cập nhật tùy chỉnh
  void _updateProfile(UserModel Function(UserModel) updateUser) async {
    emit(_Loading());
    try {
      final user = authRepository.getUser();
      if (user == null) {
        emit(_Error('User not found'));
        return;
      }

      final updatedUser = updateUser(user);
      await _updateUserInfo(updatedUser);

      emit(_Loaded());
    } catch (e) {
      logger.e('Error updating profile: $e');
      emit(_Error(e.toString()));
    }
  }

  Future<void> _updateUserInfo(UserModel user) async {
    await userRepository.updateAccountInfo(user);
    await authRepository.saveUserInfo(user);
  }
}
