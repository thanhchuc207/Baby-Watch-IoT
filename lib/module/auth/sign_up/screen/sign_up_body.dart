import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/form_bloc.dart' as form;

import '../../../../generated/assets.gen.dart';
import '../cubit/sign_up_cubit.dart';

class SignUpBody extends StatelessWidget {
  final TextEditingController codeSystemController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(listener: (context, state) {
      if (state is SignUpSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng ký thành công")),
        );

        context.router.back();
      } else if (state is SignUpError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }, child: BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, stateAuth) {
        return BlocBuilder<form.FormBloc, form.FormState>(
          builder: (context, stateForm) {
            String? phoneError;
            String? codeSystemError;
            String? usernameError;

            bool isLoading = stateAuth is SignUpLoading;

            bool isSignUpEnabled = false;

            // Kiểm tra trạng thái lỗi và loading
            stateForm.whenOrNull(
              error: (usernameErrorState, codeSystemErrorState, phoneErrorState,
                  _) {
                codeSystemError = codeSystemErrorState;
                phoneError = phoneErrorState;
                usernameError = usernameErrorState;
              },
            );

            isSignUpEnabled = codeSystemError == null &&
                phoneError == null &&
                usernameError == null &&
                codeSystemController.text.isNotEmpty &&
                phoneNumberController.text.isNotEmpty &&
                usernameController.text.isNotEmpty;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Assets.images.logo.image(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 48.0),
                                  child: Assets.images.logoText.image(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                ),
                                TextField(
                                  controller: codeSystemController,
                                  decoration: InputDecoration(
                                    labelText: 'Mã hệ thống',
                                    errorText: codeSystemError,
                                    labelStyle: TextStyle(color: Colors.grey),
                                  ),
                                  onChanged: (value) {
                                    context.read<form.FormBloc>().add(
                                          form.FormEvent.codeSystemChanged(
                                              value),
                                        );
                                  },
                                ),
                                TextField(
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType
                                      .phone, // Chỉ định bàn phím dạng số điện thoại
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Chỉ cho phép nhập số
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Số điện thoại',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    errorText: phoneError,
                                    border:
                                        UnderlineInputBorder(), // Đổi sang gạch chân
                                  ),
                                  onChanged: (value) {
                                    context.read<form.FormBloc>().add(
                                          form.FormEvent.phoneChanged(value),
                                        );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 32),
                                  child: TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      labelText: 'Họ và tên',
                                      errorText: usernameError,
                                      labelStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) {
                                      context.read<form.FormBloc>().add(
                                            form.FormEvent.usernameChanged(
                                                value),
                                          );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: isSignUpEnabled
                                        ? () async {
                                            FocusScope.of(context).unfocus();
                                            context.read<SignUpCubit>().signUp(
                                                  codeSystemController.text,
                                                  phoneNumberController.text,
                                                  usernameController.text,
                                                );
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      backgroundColor: isSignUpEnabled
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors
                                              .grey, // disable color when not enabled
                                    ),
                                    child: const Text('Đăng Ký'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đã có tài khoản? '),
                          GestureDetector(
                            onTap: () {
                              context.router.back();
                            },
                            child: Text(
                              'Đăng nhập ngay',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        );
      },
    ));
  }
}
