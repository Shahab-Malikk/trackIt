import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseCategory {
  final String name;
  final String id;

  ExpenseCategory({required this.name, required this.id});

// Factory method to create an ExpenseCategory object from a Firestore document
  factory ExpenseCategory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExpenseCategory(
      name: data['name'] ?? '',
      id: doc.id,
    );
  }
}
