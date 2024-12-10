part of 'storage_cubit.dart';

@freezed
class StorageState with _$StorageState {
  const factory StorageState.initial() = _Initial;
  const factory StorageState.loaded(List<Map<String, dynamic>> imageUrls,
      List<Map<String, dynamic>> audioUrls) = _Loaded;
  const factory StorageState.error(String message) = _Error;
}
