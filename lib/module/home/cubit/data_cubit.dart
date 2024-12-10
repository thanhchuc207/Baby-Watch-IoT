import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

class DataCubit extends Cubit<Map<String, bool>> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('data_observer/pbl6_01');

  DataCubit() : super({'is_updated_audio': false, 'is_updated_image': false}) {
    _listenToDatabase();
  }

  void _listenToDatabase() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        emit({
          'is_updated_audio': data['is_updated_audio'] ?? false,
          'is_updated_image': data['is_updated_image'] ?? false,
        });
      }
    });
  }
}
