import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../module/auth/sign_in/screen/sign_in_screen.dart';
import '../../module/auth/sign_up/screen/sign_up_screen.dart';
import '../../module/home/page/home_page.dart';
import '../../module/main_containter/main_screen.dart';

import '../../module/media/page/media_page.dart';
import '../../module/user/profile/page/profile_page.dart';
import '../../module/splash/presentation/splash_screen.dart';

import 'route_path.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(
    replaceInRouteName: 'Screen|Page,Route') //HomePage -> HomeRoute
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: SplashRoute.page,
          path: Routers.splash,
          transitionsBuilder:
              TransitionsBuilders.fadeIn, // Sử dụng hiệu ứng fade-in
          durationInMilliseconds: 500, // Thời gian chuyển cảnh
        ), // Màn hình splash đầu tiên

        AutoRoute(
          page: MainRoute.page,
          path: Routers.main,
          children: [
            AutoRoute(page: HomeRoute.page, path: Routers.homePage),
            AutoRoute(page: MediaRoute.page, path: Routers.mediaPage),
            AutoRoute(page: ProfileRoute.page, path: Routers.profilePage),
          ],
        ),

        AutoRoute(page: SignInRoute.page, path: Routers.signIn),
        AutoRoute(page: SignUpRoute.page, path: Routers.signUp),
      ];
}
