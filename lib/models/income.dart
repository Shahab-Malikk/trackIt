import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Income {
  final String id;
  final DateTime date;
  final String description;
  final String paidBy;
  final double amount;

  Income(
      {required this.date,
      required this.description,
      required this.paidBy,
      required this.id,
      required this.amount});

  String get formattedDate {
    return formatter.format(date);
  }

  factory Income.fromMap(Map<String, dynamic> data) {
    return Income(
      id: data['id'],
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      paidBy: data['paidBy'] ?? '',
      amount: data['amount'] ?? '',
    );
  }
}
