import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/enums/enums.dart';
import '../../../data/model/notification_model.dart';
import '../cubit/home_cubit.dart';
import 'package:intl/intl.dart';

import '../widgets/weekly_calendart.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, stateHome) {
          return Column(
            children: [
              WeeklyCalendar(),
              _buildFilterBar(context),
              Expanded(
                child: stateHome.when(
                  initial: (selectedDate) => _buildInitial(),
                  loading: (selectedDate) => _buildLoading(),
                  loaded: (selectedDate, notifications) =>
                      _buildLoaded(notifications),
                  error: (selectedDate, errorMessage) =>
                      _buildError(errorMessage),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInitial() {
    return const Center(child: Text("Chọn ngày để xem thông báo"));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoaded(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return const Center(child: Text("Không có thông báo"));
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        final notificationType =
            NotificationTypeExtension.fromContent(notification.content);

        // Định dạng ngày và giờ
        final dateFormatter = DateFormat("dd 'Th'MM");
        final timeFormatter = DateFormat("HH:mm");
        final formattedDate = dateFormatter.format(notification.createAt!);
        final formattedTime = timeFormatter.format(notification.createAt!);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: notificationType.icon), // Biểu tượng
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.content,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          maxLines: 4,
                        ),
                        Text(formattedDate,
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.grey),
                      const SizedBox(width: 16),
                      Text(formattedTime, style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(String errorMessage) {
    return Center(child: Text("Error: $errorMessage"));
  }

  Widget _buildFilterBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: Row(
        children: [
          // Nút Filter
          Flexible(
            child: InkWell(
              child: Row(
                children: [
                  Icon(Icons.filter_list,
                      color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      context.watch<HomeCubit>().filterType ?? 'Tất cả',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // onTap: () {
              //   // _showBottomSheet(context);
              // },
            ),
          ),

          const SizedBox(width: 16), // Khoảng cách giữa các phần tử

          // Nút Sort by price
          Flexible(
            child: InkWell(
              onTap: () {
                _showBottomSheetOrderTime(context);
              },
              child: Row(
                children: [
                  Icon(Icons.swap_vert,
                      color: Theme.of(context).colorScheme.onSurface),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      context.watch<HomeCubit>().isAscending
                          ? "Thời gian tăng dần"
                          : "Thời gian giảm dần",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context
                    .read<HomeCubit>()
                    .updateFilterType(null); // Hiển thị tất cả thông báo
              },
              child: const ListTile(
                title: Text('Tất cả thông báo'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context
                    .read<HomeCubit>()
                    .updateFilterType(NotificationType.hungry.getString());
              },
              child: ListTile(
                title: Text(NotificationType.hungry.getString()),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context
                    .read<HomeCubit>()
                    .updateFilterType(NotificationType.sleepy.getString());
              },
              child: ListTile(
                title: Text(NotificationType.sleepy.getString()),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context
                    .read<HomeCubit>()
                    .updateFilterType(NotificationType.tired.getString());
              },
              child: ListTile(
                title: Text(NotificationType.tired.getString()),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.read<HomeCubit>().updateFilterType(
                    NotificationType.lyingTooLong.getString());
              },
              child: ListTile(
                title: Text(NotificationType.lyingTooLong.getString()),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.read<HomeCubit>().updateFilterType(
                    NotificationType.lyingFaceDownTooLong.getString());
              },
              child: ListTile(
                title: Text(NotificationType.lyingFaceDownTooLong.getString()),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheetOrderTime(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Đóng BottomSheet sau khi chọn
                context.read<HomeCubit>().updateSortOrder(true);
              },
              child: const ListTile(
                title: Text('Tăng dần'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Đóng BottomSheet sau khi chọn
                context.read<HomeCubit>().updateSortOrder(false);
              },
              child: ListTile(
                title: Text('Giảm dần'),
              ),
            ),
          ],
        );
      },
    );
  }
}
