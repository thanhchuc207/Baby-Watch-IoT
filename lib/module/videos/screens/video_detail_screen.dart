import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/notification_model.dart';
import '../cubit/orientation_cubit.dart';
import '../cubit/video_controller_cubit.dart';
import '../cubit/video_overplay_controller_cubit.dart';
import 'video_detail_body.dart';

@RoutePage()
class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              VideoControllerCubit()..initializeVideo(notification.videoURL),
        ),
        BlocProvider(
          create: (context) => OrientationCubit(),
        ),
        BlocProvider(create: (context) => VideoOverplayControllerCubit()),
      ],
      child: VideoDetailBody(notification: notification),
    );
  }

  // Widget tạo một nút biểu tượng với văn bản bên dưới (được làm đẹp)
  Widget _buildStyledButton(IconData icon, String label, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 24,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
