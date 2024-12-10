import '../../data/repository/notification_repository.dart';
import '../../data/repository/user_repository.dart';
import '../../module/auth/sign_in/cubit/auth_cubit.dart';
import '../../data/repository/auth_repository.dart';
import '../../module/home/cubit/audio_cubit.dart';
import '../../module/home/cubit/storage_cubit.dart';
import 'di/getit_utils.dart';

final authRepository = getIt<AuthRepository>();
final notificationRepository = getIt<NotificationRepository>();
final userRepository = getIt<UserRepository>();
final authCubit = getIt<AuthCubit>();
final storageCubit = getIt<StorageCubit>();
final audioCubit = getIt<AudioCubit>();
