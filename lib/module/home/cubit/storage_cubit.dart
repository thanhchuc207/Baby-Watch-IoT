import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../core/locators/locator.dart';
import '../../../core/utils/logger.dart';

part 'storage_state.dart';
part 'storage_cubit.freezed.dart';

@lazySingleton
class StorageCubit extends Cubit<StorageState> {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  late final String userId;

  StreamSubscription? _notificationsSubscription;

  StorageCubit() : super(StorageState.initial()) {
    userId = authRepository.getUser()!.code;

    load(
      "",
    );
  }

  void listenToNotifications(DateTime date) {
    _notificationsSubscription?.cancel();

    _notificationsSubscription =
        databaseRef.child('data_observer/$userId').onValue.listen((event) {
      final snapshot = event.snapshot;

      if (snapshot.exists) {
      } else {}
    }, onError: (error) {
      logger.e("Error fetching notifications in realtime: $error");
    });
  }

  void load(String directoryPath, {String? codeSystem}) async {
    codeSystem ??= authRepository.getUser()!.code;

    try {
      final ListResult result =
          await _firebaseStorage.ref(directoryPath).listAll();
      final List<Map<String, dynamic>> imageFiles = [];
      final List<Map<String, dynamic>> audioFiles = [];

      for (final Reference ref in result.items) {
        final String url = await ref.getDownloadURL();
        final FullMetadata metadata = await ref.getMetadata();
        final DateTime lastModified = metadata.updated ?? DateTime.now();
        final String fileName = ref.name;

        // Check if the filename matches the format "codeSystem_image" with .jpg or .png extension
        if (fileName == ('${codeSystem}_image.jpg') &&
            (fileName.endsWith('.jpg') || fileName.endsWith('.png'))) {
          imageFiles.add({
            'url': url,
            'lastModified': lastModified,
          });
        }
        // Check if the filename matches the format "codeSystem_audio" with .mp3 or .wav extension
        else if (fileName.startsWith('${codeSystem}_audio') &&
            (fileName.endsWith('.mp3') || fileName.endsWith('.wav'))) {
          audioFiles.add({
            'url': url,
            'lastModified': lastModified,
          });
        }
      }

      emit(StorageState.loaded(imageFiles, audioFiles));
    } catch (e) {
      logger.e(e.toString());
      emit(StorageState.error(e.toString()));
    }
  }
}
