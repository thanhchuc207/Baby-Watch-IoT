import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/logger.dart';
import '../../../../data/local/storage.dart';
import '../../../../data/model/user_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  Future<void> signUp(String systemCode, String phone, String name) async {
    emit(SignUpLoading());

    try {
      // Step 1: Check if the system code exists in 'system'
      final systemSnapshot = await databaseRef
          .child('system')
          .orderByChild('code')
          .equalTo(systemCode)
          .get();

      if (systemSnapshot.exists) {
        // Step 2: Check if the phone number already exists under 'accounts/systemCode'
        final accountsRef = databaseRef.child('accounts/$systemCode');
        final accountSnapshot =
            await accountsRef.orderByChild('phone').equalTo(phone).get();

        if (accountSnapshot.exists) {
          // Phone number already exists within this system code
          emit(SignUpError('Số điện thoại đã tồn tại trong hệ thống này.'));
          logger.e('Số điện thoại đã tồn tại trong hệ thống này.');
        } else {
          // Phone number does not exist, proceed to add new account under 'accounts/systemCode'
          final newAccountRef = accountsRef.push();

          final accountData = UserModel(
              code: systemCode,
              phone: phone,
              name: name,
              deviceToken: Storage.deviceId);

          await newAccountRef.set(accountData.toJson());

          emit(SignUpSuccess(accountData));
          logger
              .i('Account created successfully under system code: $systemCode');
        }
      } else {
        // System code does not exist
        emit(SignUpError('Mã hệ thống không tồn tại'));
        logger.e('Mã hệ thống không tồn tại');
      }
    } catch (e) {
      logger.e('Error signing up: $e');
      emit(SignUpError('Có lỗi xảy ra. Vui lòng thử lại.'));
    }
  }
}
