import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../core/language/lang_cubit.dart';
import '../../core/locators/di/getit_utils.dart';
import '../../generated/l10n.dart';
import '../../module/switch_theme/bloc/switch_theme_bloc.dart';
import '../../shared/themes/dark_mode.dart';
import '../../shared/themes/light_mode.dart';
import 'app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();
    final talker = getIt<Talker>();

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<LangCubit, Locale>(builder: (context, locale) {
          return BlocBuilder<SwitchThemeBloc, SwitchThemeState>(
              builder: (context, state) {
            return MaterialApp.router(
              theme: lightMode, // Sử dụng theme lightMode
              title: 'Edu Smart App',
              darkTheme: darkMode, // Sử dụng theme darkMode
              themeMode: state.themeMode,
              debugShowCheckedModeBanner: false, // Tắt banner debug
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              locale: locale, // Sử dụng locale hiện tại
              routerConfig: router.config(
                navigatorObservers: () => [TalkerRouteObserver(talker)],
              ),
            );
          });
        });
      },
    );
  }
}
