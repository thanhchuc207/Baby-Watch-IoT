import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'audio_state.dart';
part 'audio_cubit.freezed.dart';

@lazySingleton
class AudioCubit extends Cubit<AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioCubit() : super(AudioState.initial()) {
    // Lắng nghe sự kiện hoàn tất của âm thanh
    _audioPlayer.onPlayerComplete.listen((event) {
      emit(AudioState.stopped());
    });
  }

  Future<void> playAudio(String url) async {
    try {
      if (state is _AudioStatePlaying &&
          (state as _AudioStatePlaying).url == url) {
        // Nếu âm thanh đang phát và người dùng nhấn lại vào cùng âm thanh, dừng lại
        await _audioPlayer.stop();
        emit(AudioState.stopped());
      } else {
        // Dừng âm thanh hiện tại (nếu có) trước khi phát âm thanh mới
        await _audioPlayer.stop();

        // Phát âm thanh từ URL mới
        await _audioPlayer.play(UrlSource(url));
        emit(AudioState.playing(url));
      }
    } catch (e) {
      emit(AudioState.error("Failed to play audio: $e"));
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      emit(AudioState.stopped());
    } catch (e) {
      emit(AudioState.error("Failed to stop audio: $e"));
    }
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }
}
