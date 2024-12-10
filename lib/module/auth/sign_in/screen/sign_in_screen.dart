import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/form_bloc.dart';
import 'sign_in_body.dart';

@RoutePage()
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
      body: BlocProvider(
        create: (context) => FormBloc(),
        child: SignInBody(),
      ),
    );
  }
}
