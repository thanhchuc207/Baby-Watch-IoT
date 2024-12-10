import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants/constants.dart';
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
        BlocProvider<MediaCubit>(
          create: (_) => MediaCubit(),
        ),
        BlocProvider<DataCubit>(
          create: (_) => DataCubit(),
        ),
      ],
      child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              AppConstants.titleMedia,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
              ),
            ),
          ),
          body: MediaBody()),
    );
  }
}
