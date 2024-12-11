import 'package:flutter/widgets.dart';

import '../../../data/model/notification_model.dart';
import '../widgets/video_display_content.dart';

class VideoDetailBody extends StatelessWidget {
  const VideoDetailBody({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return _buildLoaded(context, notification);
  }

  Widget _buildLoaded(
      BuildContext context, NotificationModel videoNotification) {
    return VideoDisplayContent(
      videoNotification: videoNotification,
    );
  }
}
