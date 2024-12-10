import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app/route_path.dart';
import '../../../../core/utils/logger.dart';
import '../../../../generated/assets.gen.dart';
import '../../bloc/form_bloc.dart' as form;
import '../cubit/auth_cubit.dart';

class SignInBody extends StatelessWidget {
  const SignInBody({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeSystemController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    return BlocListener<AuthCubit, AuthState>(listener: (context, stateAuth) {
      if (stateAuth is AuthSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thành công!'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );

        context.router.replaceNamed(Routers.main);

        logger.i('User: ${stateAuth.user.toJson()}');
      } else if (stateAuth is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(stateAuth.errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }, child: BlocBuilder<AuthCubit, AuthState>(
      builder: (context, stateAuth) {
        return BlocBuilder<form.FormBloc, form.FormState>(
          builder: (context, stateForm) {
            String? phoneError;
            String? codeSystemError;
            bool isLoading = stateAuth is AuthLoading;

            bool isSignInEnabled = false;

            // Kiểm tra trạng thái lỗi và loading
            stateForm.whenOrNull(
              error: (_, codeSystemErrorState, phoneErrorState, __) {
                codeSystemError = codeSystemErrorState;
                phoneError = phoneErrorState;
              },
            );

            isSignInEnabled = codeSystemError == null &&
                phoneError == null &&
                codeSystemController.text.isNotEmpty &&
                phoneNumberController.text.isNotEmpty;

            return Stack(children: [
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: TextField(
                                  controller: codeSystemController,
                                  decoration: InputDecoration(
                                    labelText: 'Mã hệ thống',
                                    errorText: codeSystemError,
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border:
                                        UnderlineInputBorder(), // Đổi sang gạch chân
                                  ),
                                  onChanged: (value) {
                                    context.read<form.FormBloc>().add(
                                          form.FormEvent.codeSystemChanged(
                                              value),
                                        );
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, bottom: 32),
                                child: TextField(
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
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isSignInEnabled
                                      ? () async {
                                          FocusScope.of(context).unfocus();
                                          context.read<AuthCubit>().signIn(
                                              codeSystemController.text,
                                              phoneNumberController.text);
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor: isSignInEnabled
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors
                                            .grey, // disable color when not enabled
                                  ),
                                  child: const Text('Đăng nhập'),
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
                        const Text('Chưa có tài khoản? '),
                        GestureDetector(
                          onTap: () {
                            context.router.pushNamed(Routers.signUp);
                          },
                          child: Text(
                            'Đăng ký ngay',
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
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ]);
          },
        );
      },
    ));
  }
}
