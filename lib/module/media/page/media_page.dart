import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/cubit/data_cubit.dart';
import '../cubit/media_cubit.dart';
import 'media_body.dart';

@RoutePage()
class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MediaCubit>(create: (_) => MediaCubit()),
        BlocProvider<DataCubit>(
          create: (_) => DataCubit(),
        ),
      ],
      child: MediaBody(),
    );
  }
}
