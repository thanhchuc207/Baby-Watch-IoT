import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_state.dart';
part 'media_cubit.freezed.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaState.initial()) {
    updateVideoUrl('http://192.168.1.2:5123/video');
  }

  // Cập nhật trạng thái loading
  void setLoading(bool loading) {
    emit(MediaState.loading(loading: loading));
  }

  // Cập nhật video URL
  void updateVideoUrl(String url) {
    emit(MediaState.loaded(videoUrl: url));
  }
}
