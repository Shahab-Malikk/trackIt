import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String subCategory;
  final String description;
  final String paidBy;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.subCategory,
    required this.description,
    required this.paidBy,
  }) : id = uuid.v4();

  factory Expense.fromMap(Map<String, dynamic> data) {
    return Expense(
      title: data['title'] ?? '', // Replace 'name' with your actual field name
      amount: data['amount']?.toDouble() ??
          0.0, // Replace 'amount' with your actual field name
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'],
      subCategory: data['subCategory'],
      description: data['description'] ?? ' ',
      paidBy: data['paidBy'] ?? ' ',
    );
  }

  String get formattedDate {
    return formatter.format(date);
  }
}

// Includes functionalities related to the Expenses i.e Adding a expense , fetching all expenses
class ExpenseService {
  final FirestoreServices _firestoreService;

  ExpenseService(this._firestoreService);

  CollectionReference get _expensesCollection =>
      _firestoreService.db.collection('expenses');

  Future<List<Expense>> fetchExpenses() async {
    QuerySnapshot snapshot = await _expensesCollection.get();
    return snapshot.docs
        .map((doc) => Expense.fromMap(
            doc.data() as Map<String, dynamic>)) // Extracting the 'name' field
        .toList();
  }

  Future<void> storeExpenseInDb(Expense expense) {
    return _expensesCollection
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
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
