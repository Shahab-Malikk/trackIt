import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/firestore_services.dart';

class UserDataService {
  final FirestoreServices _firestoreService;

  UserDataService(this._firestoreService);

  CollectionReference get _usersCollection =>
      _firestoreService.db.collection('users');

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
