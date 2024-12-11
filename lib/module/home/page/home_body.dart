import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/notification_model.dart';
import '../../../shared/widgets/layout_grid.dart';
import '../cubit/home_cubit.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    int countItemInRow = 1;
    if (MediaQuery.of(context).size.width > 600) {
      countItemInRow = 2;
    } else if (MediaQuery.of(context).size.width > 1200) {
      countItemInRow = 3;
    } else if (MediaQuery.of(context).size.width > 1800) {
      countItemInRow = 4;
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              error: (_, errorMessage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                  ),
                );
              },
            );
          },
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, stateHome) {
          return stateHome.when(
            error: (selectedDate, errorMessage) => _buildError(errorMessage),
            loading: (selectedDate) => _buildLoading(),
            initial: (selectedDate) => _buildInitial(),
            loaded: (selectedDate, notifications) =>
                _buildLoaded(notifications, context, countItemInRow),
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

  Widget _buildLoaded(List<NotificationModel> notifications,
      BuildContext context, int countItemInRow) {
    if (notifications.isEmpty) {
      return const Center(child: Text("Không có thông báo"));
    }

    return RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ItemCardLayoutGrid(
                crossAxisCount: countItemInRow,
                notificationList: notifications,
              ),
            ),
          ],
        ));
  }

  Widget _buildError(String errorMessage) {
    return Center(child: Text("Error: $errorMessage"));
  }
}
