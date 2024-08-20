import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/firestore_services.dart';

class ExpenseCategory {
  final String name;
  final String id;

  ExpenseCategory({required this.name, required this.id});

  factory ExpenseCategory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExpenseCategory(
      name: data['name'] ?? '',
      id: doc.id,
    );
  }
}

// Includes methods related to the Categories Functionlities i.e. fetching categories, fetching subcategories

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

  Future<List<String>> getContributors() async {
    final querySnapshot = await _contributorsCollection.get();

    return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
  }
}
