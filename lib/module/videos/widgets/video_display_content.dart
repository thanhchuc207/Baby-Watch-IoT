import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_baby_watch/common/extensions/date_x.dart';
import 'package:iot_baby_watch/data/model/notification_model.dart';

import '../../../core/utils/logger.dart';
import '../cubit/video_controller_cubit.dart';

import 'video_player_widget.dart';

class VideoDisplayContent extends StatelessWidget {
  final NotificationModel videoNotification;
  VideoDisplayContent({
    super.key,
    required this.videoNotification,
  });

  final ValueNotifier<double> heightFactorNotifier = ValueNotifier(0.6);

  @override
  Widget build(BuildContext context) {
    int height = MediaQuery.of(context).size.height.toInt();
    return BlocBuilder<VideoControllerCubit, VideoControllerState>(
        builder: (context, stateVideoControl) {
      return OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          logger.d('Orientation: Landscape');
          // onOrientationLandscape(context, stateVideoControl);
        }
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text("Xem lại video", style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.3),
                      VideoPlayerWidget(
                        urlVideo: videoNotification.videoURL,
                      ),
                      // Nội dung thông báo
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              videoNotification.content,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            Text(
                              videoNotification.createAt!.toFormattedString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      });
    });
  }
}
