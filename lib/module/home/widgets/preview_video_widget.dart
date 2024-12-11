import 'package:flutter/material.dart';
import 'package:iot_baby_watch/common/extensions/date_x.dart';

import '../../../../shared/widgets/image_widget.dart';
import '../../../data/model/notification_model.dart';

class VideoPreviewWidget extends StatelessWidget {
  const VideoPreviewWidget({
    super.key,
    required this.notificationModel,
    required this.onItemTap,
  });

  final NotificationModel notificationModel;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: ImageWidget(
                  imageUrl: '',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notificationModel.content,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        notificationModel.createAt!.toFormattedString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
