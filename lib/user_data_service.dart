import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
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
        print('No data found for user with UID: $userId');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<List<Expense>> fetchExpenses(String userId) async {
    CollectionReference expenseCollection =
        _usersCollection.doc(userId).collection('expenses');
    QuerySnapshot snapshot = await expenseCollection.get();
    return snapshot.docs
        .map((doc) => Expense.fromMap(
            doc.data() as Map<String, dynamic>)) // Extracting the 'name' field
        .toList();
  }

  Future<void> storeExpenseInDb(Expense expense, String userId) {
    CollectionReference expenseCollection =
        _usersCollection.doc(userId).collection('expenses');

    return expenseCollection
        .add({
          'id': expense.id,
          'title': expense.title,
          'date': expense.date,
          'category': expense.category,
          'subCategory': expense.subCategory,
          'amount': expense.amount,
          'description': expense.description,
          'paidBy': expense.paidBy,
        })
        .then((value) => print("Expense Id"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
