import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/logger.dart';
import '../model/user_model.dart';

@singleton
class UserRepository {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  Future<void> updateAccountInfo(UserModel updatedData) async {
    try {
      // Get the reference to the specific codeSystem
      final codeSystemRef = databaseRef.child('accounts/${updatedData.code}');

      // Fetch the data for the specific codeSystem
      final snapshot = await codeSystemRef.get();

      if (snapshot.exists) {
        // Iterate over accounts within the codeSystem to find the matching phone
        for (final account in snapshot.children) {
          final accountPhone = account.child('phone').value as String?;

          if (accountPhone == updatedData.phone) {
            // Update the account information
            await account.ref.update(updatedData.toJson());
            logger.i('Account information updated successfully.');
            return;
          }
        }
        logger.i('No matching account found with the provided phone.');
      } else {
        logger.e('No data found for the specified codeSystem.');
      }
    } catch (e) {
      logger.e('Error updating account information: $e');
    }
  }
}
