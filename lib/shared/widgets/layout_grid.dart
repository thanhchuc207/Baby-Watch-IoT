import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../core/app/app_router.dart';
import '../../data/model/notification_model.dart';
import '../../module/home/widgets/preview_video_widget.dart';

class ItemCardLayoutGrid extends StatelessWidget {
  const ItemCardLayoutGrid({
    super.key,
    required this.crossAxisCount,
    required this.notificationList,
    this.isHistory = false,
  });

  final int crossAxisCount;
  final List<NotificationModel> notificationList;
  final bool isHistory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: LayoutGrid(
        // Tạo cột dựa trên crossAxisCount
        columnSizes: List.generate(crossAxisCount, (_) => 1.fr),
        // Tự động tạo hàng dựa trên độ dài danh sách
        rowSizes: List.generate(
          (notificationList.length / crossAxisCount)
              .ceil(), // Số hàng cần thiết
          (_) => auto,
        ),
        rowGap: 8, // Khoảng cách giữa các hàng
        columnGap: 8, // Khoảng cách giữa các cột
        children: [
          for (var i = 0; i < notificationList.length; i++)
            VideoPreviewWidget(
              notificationModel: notificationList[i],
              onItemTap: () {
                context.router
                    .push(VideoDetailRoute(notification: notificationList[i]));
              },
            ).withGridPlacement(
              columnStart: i % crossAxisCount,
              rowStart: i ~/ crossAxisCount,
            ),
        ],
      ),
    );
  }
}
