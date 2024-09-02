import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/firestore_services.dart';

class CategoryService {
  final FirestoreServices _firestoreService;
  CategoryService(this._firestoreService);
  CollectionReference get _categoryCollection =>
      _firestoreService.db.collection('categories');

  CollectionReference get _contributorsCollection =>
      _firestoreService.db.collection('paidBy');

  Future<List<ExpenseCategory>> fetchCategories() async {
    QuerySnapshot snapshot = await _categoryCollection.get();
    return snapshot.docs
        .map((doc) => ExpenseCategory.fromFirestore(doc))
        .toList();
  }

  Future<List<String>> getSubcategories(String categoryId) async {
    final querySnapshot = await _categoryCollection
        .doc(categoryId)
        .collection('subcategories')
        .get();

    return querySnapshot.docs
        .map((doc) => doc['name'] as String) // Extracting the 'name' field
        .toList();
  }

  Future<List<String>> getSenders() async {
    final querySnapshot =
        await _contributorsCollection.where('type', isEqualTo: 'sender').get();

    return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<List<String>> getRecievers() async {
    final querySnapshot = await _contributorsCollection
        .where('type', isEqualTo: 'receiever')
        .get();

    return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
  }
}
