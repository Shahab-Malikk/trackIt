import 'package:cloud_firestore/cloud_firestore.dart';
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
      title: data['title'] ??
          '', // If the title is not present, default to an empty string
      amount: data['amount']?.toDouble() ??
          0.0, // If the amount is not present, default to 0.0
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
