import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/constants.dart';
import '../../../core/app/app_router.dart';
import '../../auth/sign_in/cubit/auth_cubit.dart';
import '../cubit/calendar_cubit.dart';
import 'home_body.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarCubit>(
          create: (_) => CalendarCubit(),
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              AppConstants.titleHome,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  context
                      .read<AuthCubit>()
                      .signOut(); // Gọi phương thức signOut

                  context.router.replaceAll([const SignInRoute()]);
                },
              ),
            ],
          ),
          body: HomeBody()),
    );
  }
}
