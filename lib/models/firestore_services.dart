import 'package:cloud_firestore/cloud_firestore.dart';

// Class to intialize FirebaseFireStore for reusability
class FirestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;
}

final fireStoreService = FirestoreServices();
