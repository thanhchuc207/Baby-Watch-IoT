import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../common/extensions/data_x.dart';
import '../../../core/locators/locator.dart';
import '../../../core/utils/logger.dart';
import '../../../data/model/notification_model.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  bool isAscending = false;
  String? filterType;

  late final String userId;
  StreamSubscription? _notificationsSubscription;

  // Map để lưu dữ liệu đã tải theo ngày (chỉ lưu phần ngày, tháng, năm)
  final Map<DateTime, List<NotificationModel>> _cachedNotifications = {};

  HomeCubit() : super(HomeState.initial(selectedDate: DateTime.now())) {
    userId = authRepository.getUser()!.code;
    listenToNotifications(normalizeDate(state.selectedDate));
  }

  /// [listenToNotifications] Hàm để lắng nghe thông báo từ Firebase Realtime Database
  void listenToNotifications(DateTime date) {
    _notificationsSubscription?.cancel();

    emit(HomeState.loading(selectedDate: date));

    _notificationsSubscription =
        databaseRef.child('notification/$userId').onValue.listen((event) {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
        final notifications = <NotificationModel>[];

        snapshot.children.forEach((child) {
          final data = child.value as Map<dynamic, dynamic>;
          notifications
              .add(NotificationModel.fromJson(Map<String, dynamic>.from(data)));
        });

        final filteredNotifications = _filterNotificationsByDate(
          notifications,
          normalizeDate(state.selectedDate),
        );

        _processNotifications(filteredNotifications);
      } else {
        emit(HomeState.loaded(
            selectedDate: normalizeDate(state.selectedDate),
            notifications: []));
      }
    }, onError: (error) {
      logger.e("Error fetching notifications in realtime: $error");
      emit(HomeState.error(
          selectedDate: normalizeDate(state.selectedDate),
          errorMessage: "Error fetching notifications"));
    });
  }

  // Xử lý danh sách thông báo (lọc và sắp xếp)
  void _processNotifications(List<NotificationModel> notifications) {
    if (filterType != null) {
      notifications = notifications.where((notification) {
        return notification.content == filterType;
      }).toList();
    }

    notifications.sort((a, b) {
      return isAscending
          ? a.createAt!.compareTo(b.createAt!)
          : b.createAt!.compareTo(a.createAt!);
    });

    final normalizedDate = normalizeDate(state.selectedDate);
    _cachedNotifications[normalizedDate] = notifications; // Lưu dữ liệu vào Map

    emit(HomeState.loaded(
        selectedDate: normalizedDate, notifications: notifications));
  }

  // Hàm để cập nhật ngày được chọn
  void updateSelectedDate(DateTime date) {
    final normalizedDate = normalizeDate(date); // Chuẩn hóa ngày
    logger.i("Selected date: $normalizedDate");

    listenToNotifications(normalizedDate);
  }

  /// [_filterNotificationsByDate] Hàm để lọc thông báo theo ngày
  List<NotificationModel> _filterNotificationsByDate(
      List<NotificationModel> notifications, DateTime date) {
    final dateFormat = DateFormat("yyyy-MM-dd");
    final formattedDate = dateFormat.format(date);

    return notifications.where((notification) {
      final notificationDate = dateFormat.format(notification.createAt!);
      return notificationDate == formattedDate;
    }).toList();
  }

  /// [updateFilterType] Hàm để cập nhật loại thông báo cần lọc
  void updateFilterType(String? type) {
    filterType = type;

    if (state is _Loaded) {
      final loadedState = state as _Loaded;

      // Lọc theo loại thông báo
      final filteredNotifications = type != null
          ? loadedState.notifications
              .where((notification) => notification.content == type)
              .toList()
          : loadedState.notifications;

      emit(HomeState.loaded(
          selectedDate: state.selectedDate,
          notifications: filteredNotifications));
    }
  }

  /// [updateSortOrder] Hàm để cập nhật thứ tự sắp xếp
  void updateSortOrder(bool ascending) {
    isAscending = ascending;

    if (state is _Loaded) {
      final loadedState = state as _Loaded;

      // Sắp xếp lại danh sách thông báo
      final sortedNotifications =
          List<NotificationModel>.from(loadedState.notifications)
            ..sort((a, b) {
              return ascending
                  ? a.createAt!.compareTo(b.createAt!)
                  : b.createAt!.compareTo(a.createAt!);
            });

      emit(HomeState.loaded(
          selectedDate: state.selectedDate,
          notifications: sortedNotifications));
    }
  }

  // Hủy lắng nghe khi Cubit bị đóng
  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
