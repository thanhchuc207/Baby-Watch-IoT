import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app/app_router.dart';
import '../../../../core/locators/locator.dart';
import '../../../../shared/widgets/section_title.dart';
import '../../../auth/sign_in/cubit/auth_cubit.dart';
import '../../../switch_theme/bloc/switch_theme_bloc.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/button_select_option_user.dart';
import '../widgets/switch_widget.dart';
import '../widgets/time_picker_dialog.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
        );
      },
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SectionTitle(title: 'Tính năng'),
                SwitchWidget(
                  title: 'Chế độ tối',
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (bool value) {
                    BlocProvider.of<SwitchThemeBloc>(context)
                        .add(SwitchThemeEvent.toggleTheme());
                  },
                  icon: Icons.dark_mode_outlined,
                ),
                // Language
                CustomButtonInPageUser(
                  icon: Icons.timer_sharp,
                  initialText: 'Thời gian thay đổi tư thế',
                  onPressed: () async {
                    showTimePickerDialog(context);
                  },
                ),
                SwitchWidget(
                  title: 'Bật thông báo',
                  value: context.watch<ProfileCubit>().enableNotification,
                  onChanged: (bool value) {
                    context
                        .read<ProfileCubit>()
                        .updateEnableNotification(value);
                  },
                  icon: Icons.notifications_outlined,
                ),

                const Divider(),
                SectionTitle(title: 'Thông tin'),
                CustomButtonInPageUser(
                  icon: Icons.info,
                  initialText: 'Thông tin phiên bản',
                  subText: '1.0.0',
                  onPressed: () async {
                    notificationRepository.generateFakeNotifications();
                  },
                  enableTrailing: false,
                ),
              ],
            ),
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<AuthCubit>()
                            .signOut(); // Gọi phương thức signOut

                        context.router.replaceAll([const SignInRoute()]);
                      },
                      child: Text(
                        'Đăng xuất',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryFixed,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
