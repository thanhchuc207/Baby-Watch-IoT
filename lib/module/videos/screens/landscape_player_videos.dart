import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../cubit/orientation_cubit.dart';
import '../cubit/video_overplay_controller_cubit.dart';
import '../widgets/video_overplay_landscape.dart';

@RoutePage()
class LandscapeModeVideosScreen extends StatefulWidget {
  const LandscapeModeVideosScreen(
      {super.key,
      required this.controller,
      required this.orientationCubit,
      required this.videoOverplayControllerCubit});

  final VideoPlayerController controller;
  final OrientationCubit orientationCubit;
  final VideoOverplayControllerCubit videoOverplayControllerCubit;
  @override
  State<LandscapeModeVideosScreen> createState() =>
      _LandscapeModeVideosScreenState();
}

class _LandscapeModeVideosScreenState extends State<LandscapeModeVideosScreen> {
  Future<void> _setLandscapeMode() async {
    try {
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []); // Ẩn thanh trạng thái
    } catch (e) {
      // Xử lý lỗi
    }
  }

  Future<void> _resetOrientation() async {
    try {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values); // Hiện lại thanh trạng thái
    } catch (e) {
      // Xử lý lỗi
    }
  }

  @override
  void initState() {
    super.initState();
    _setLandscapeMode();
  }

  @override
  void dispose() {
    _resetOrientation();
    widget.orientationCubit.changeOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: widget.orientationCubit, // Truyền OrientationCubit
        ),
        BlocProvider.value(
          value: widget
              .videoOverplayControllerCubit, // Truyền VideoOverplayControllerCubit
        ),
      ],
      child: Stack(children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(widget.controller),
          ),
        ),
        Positioned.fill(
            child: VideoOverplayLandscape(
                controller: widget.controller,
                orientationCubit: widget.orientationCubit,
                videoOverplayControllerCubit:
                    widget.videoOverplayControllerCubit)),
      ]),
    );
  }
}
