import 'dart:async';
import 'dart:isolate';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_baby_watch/common/extensions/locale_x.dart';

import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/app/app_widget.dart';
import 'core/app/notification_service.dart';
import 'core/language/lang_cubit.dart';
import 'core/language/lang_repository_interface.dart';
import 'core/locators/di/getit_utils.dart';
import 'core/utils/logger.dart';
import 'data/local/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'module/auth/sign_in/cubit/auth_cubit.dart';
import 'module/home/cubit/audio_cubit.dart';
import 'module/home/cubit/home_cubit.dart';
import 'module/home/cubit/storage_cubit.dart';
import 'module/splash/bloc/splash_bloc.dart';
import 'module/switch_theme/bloc/switch_theme_bloc.dart';

import 'package:firebase_core/firebase_core.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env");

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationService.instance.initialize();

    await Storage.setup();
    await GetItUtils.setup();

    final FirebaseMessaging _messaging = FirebaseMessaging.instance;

    await _messaging.requestPermission();
    String? token = await _messaging.getToken();
    // Gọi getToken để lấy device token

    Storage.setDeviceId(token);

    final langRepository = getIt<ILangRepository>();
    final talker = getIt<Talker>();
    _setupErrorHooks(talker);
    logger.d(
        'deviceLocale - ${langRepository.getDeviceLocale().fullLanguageCode}');
    logger.d('currentLocale - ${langRepository.getLocale().fullLanguageCode}');
    logger.d('Device Token: ${Storage.deviceId}');

    Bloc.observer = TalkerBlocObserver(talker: talker);

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => getIt<LangCubit>()), // Chỉ giữ lại LangCubit

          BlocProvider(
            create: (_) => getIt<SwitchThemeBloc>(),
          ),

          BlocProvider(
            create: (_) => getIt<AuthCubit>(),
          ),

          BlocProvider(
            create: (_) => getIt<HomeCubit>(),
          ),

          BlocProvider(
            create: (_) => getIt<StorageCubit>(),
          ),

          BlocProvider<AudioCubit>(
            create: (_) => AudioCubit(),
          ),

          BlocProvider(
            create: (_) => getIt<SplashBloc>(),
          ),
        ],
        child: const AppWidget(), // Không cần MultiBlocListener
      ),
    );
  }, (error, stack) {
    getIt<Talker>().handle(error, stack);
  });
}

Future _setupErrorHooks(Talker talker, {bool catchFlutterErrors = true}) async {
  if (catchFlutterErrors) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      _reportError(details.exception, details.stack, talker);
    };
  }
  PlatformDispatcher.instance.onError = (error, stack) {
    _reportError(error, stack, talker);
    return true;
  };

  /// Web doesn't have Isolate error listener support
  if (!kIsWeb) {
    Isolate.current.addErrorListener(RawReceivePort((dynamic pair) async {
      final isolateError = pair as List<dynamic>;
      _reportError(
        isolateError.first.toString(),
        isolateError.last.toString(),
        talker,
      );
    }).sendPort);
  }
}

void _reportError(dynamic error, dynamic stackTrace, Talker talker) async {
  talker.error('Unhandled Exception', error, stackTrace);
}
