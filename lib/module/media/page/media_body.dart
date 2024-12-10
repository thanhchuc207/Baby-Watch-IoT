// ignore_for_file: must_be_immutable

import 'package:iot_baby_watch/common/extensions/string_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/locators/locator.dart';
import '../../../core/utils/logger.dart';
import '../../../generated/assets.gen.dart';
import '../../../shared/widgets/image_widget.dart';
import '../../home/cubit/audio_cubit.dart';
import '../../home/cubit/data_cubit.dart';
import '../../home/cubit/storage_cubit.dart';
import '../cubit/media_cubit.dart';

class MediaBody extends StatelessWidget {
  MediaBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Xác định số lượng cột dựa trên kích thước màn hình
    final int countItemInRow =
        _calculateColumns(MediaQuery.of(context).size.width);

    return MultiBlocListener(
      listeners: [
        BlocListener<MediaCubit, MediaState>(
          listener: (context, state) {},
        ),
        BlocListener<StorageCubit, StorageState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<DataCubit, Map<String, bool>>(
        builder: (context, stateData) {
          _handleStateUpdates(context, stateData);

          return BlocBuilder<MediaCubit, MediaState>(
            builder: (context, stateHome) {
              return BlocBuilder<StorageCubit, StorageState>(
                builder: (context, stateStorage) {
                  return stateStorage.when(
                    loaded: (imageFiles, audioFiles) => _buildLoadedView(
                      context,
                      countItemInRow,
                      imageFiles,
                      audioFiles,
                    ),
                    error: (message) => _buildErrorView(context, message),
                    initial: () => _buildLoadingView(countItemInRow, context),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Map<String, bool> previousStateData = {};

  // Tính số lượng cột dựa trên chiều rộng màn hình
  int _calculateColumns(double width) {
    if (width > 1800) return 4;
    if (width > 1200) return 3;
    if (width > 600) return 2;
    return 1;
  }

  // Xử lý khi trạng thái DataCubit thay đổi
  void _handleStateUpdates(BuildContext context, Map<String, bool> stateData) {
    final isUpdatedAudio = stateData['is_updated_audio'] ?? false;
    final isUpdatedImage = stateData['is_updated_image'] ?? false;

    if (isUpdatedAudio != previousStateData['is_updated_audio'] ||
        isUpdatedImage != previousStateData['is_updated_image']) {
      logger.d('Dữ liệu đã được cập nhật!');
      audioCubit.stopAudio();
      context.read<StorageCubit>().load("");
    }

    previousStateData = stateData;
  }

  // Xây dựng giao diện khi đang tải
  Widget _buildLoadingView(int countItemInRow, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          _buildImageGrid(context, countItemInRow, 1),
          const SizedBox(height: 16),
          _buildAudioList(context, 1),
        ],
      ),
    );
  }

  // Xây dựng giao diện khi dữ liệu đã tải
  Widget _buildLoadedView(
    BuildContext context,
    int countItemInRow,
    List<Map<String, dynamic>> imageFiles,
    List<Map<String, dynamic>> audioFiles,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        audioCubit.stopAudio();
        context.read<StorageCubit>().load("");
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            _buildImageGrid(context, countItemInRow, imageFiles.length,
                files: imageFiles),
            const SizedBox(height: 16),
            _buildAudioList(context, audioFiles.length, files: audioFiles),
          ],
        ),
      ),
    );
  }

  // Xây dựng giao diện khi xảy ra lỗi
  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<StorageCubit>().load(""),
            child: const Text("Tải lại"),
          ),
        ],
      ),
    );
  }

  // Giao diện ban đầu
  Widget _buildInitialView(BuildContext context) {
    return SizedBox.shrink();
  }

  // Tạo lưới hình ảnh
  Widget _buildImageGrid(
    BuildContext context,
    int countItemInRow,
    int itemCount, {
    List<Map<String, dynamic>>? files,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: countItemInRow,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final imageFile = files != null ? files[index] : null;
        final url = imageFile?['url'];
        final lastModified =
            imageFile?['lastModified'] as DateTime? ?? DateTime.now();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageHeader(context, lastModified),
              Expanded(
                child: url != null
                    ? ImageWidget(imageUrl: url)
                    : Container(color: Colors.grey[300]),
              ),
            ],
          ),
        );
      },
    );
  }

  // Tạo tiêu đề hình ảnh
  Widget _buildImageHeader(BuildContext context, DateTime lastModified) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Theme.of(context).colorScheme.secondary,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Assets.icons.iconImage.image(width: 32, height: 32),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hình ảnh từ camera',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                lastModified.toCustomFormat(),
                style: TextStyle(
                    fontSize: 10, color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tạo danh sách âm thanh
  Widget _buildAudioList(
    BuildContext context,
    int itemCount, {
    List<Map<String, dynamic>>? files,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final audioFile = files != null ? files[index] : null;
        final url = audioFile?['url'];
        final lastModified =
            audioFile?['lastModified'] as DateTime? ?? DateTime.now();
        final isPlaying = context.watch<AudioCubit>().state.maybeWhen(
              playing: (currentUrl) => currentUrl == url,
              orElse: () => false,
            );

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Assets.icons.iconAudio.image(width: 32, height: 32),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Âm thanh từ micro',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        lastModified.toCustomFormat(),
                        style: TextStyle(
                            fontSize: 10, color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    if (url != null) context.read<AudioCubit>().playAudio(url);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
