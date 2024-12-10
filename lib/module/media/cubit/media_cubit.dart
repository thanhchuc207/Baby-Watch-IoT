import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_state.dart';
part 'media_cubit.freezed.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaState.initial());
}
