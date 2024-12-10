import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/form_bloc.dart';
import '../cubit/sign_up_cubit.dart';
import 'sign_up_body.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Không thay đổi kích thước khi bàn phím xuất hiện
      appBar: AppBar(
        automaticallyImplyLeading: false, // Tắt nút back mặc định
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignUpCubit(),
          ),
          BlocProvider(
            create: (context) => FormBloc(),
          ),
        ],
        child: SignUpBody(),
      ),
    );
  }
}
