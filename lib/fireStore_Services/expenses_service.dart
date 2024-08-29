import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/firestore_services.dart';

class ExpensesService {
  final FirestoreServices _firestoreServices;

  ExpensesService(this._firestoreServices);

  CollectionReference get _usersCollection =>
      _firestoreServices.db.collection('users');

//Store Expenses of current Project

  Future<void> storeExpenseOfProjectInDb(
      Expense expense, String userId, String projectId) {
    CollectionReference expenseCollection = _usersCollection
        .doc(userId)
        .collection("projects")
        .doc(projectId)
        .collection("expenses");

    return expenseCollection
        .doc(expense.id)
        .set({
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

  // Fetch Expenses of current Project
  Future<List<Expense>> fetchExpensesOfCurrentProject(
      String userId, String projectId) async {
    CollectionReference expenseCollection = _usersCollection
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection("expenses");
    QuerySnapshot snapshot = await expenseCollection.get();
    return snapshot.docs
        .map((doc) => Expense.fromMap(
            doc.data() as Map<String, dynamic>)) // Extracting the 'name' field
        .toList();
  }

  Future<void> deleteExpenseOfProject(
      String userId, String projectId, String expenseId) {
    CollectionReference expenseCollection = _usersCollection
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection("expenses");
    return expenseCollection
        .doc(expenseId)
        .delete()
        .then((value) => print("Expense Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
