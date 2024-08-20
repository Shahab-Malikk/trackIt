import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Project {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final String initiatedBy;

  Project({
    required this.title,
    required this.date,
    required this.description,
    required this.initiatedBy,
  }) : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }

  factory Project.fromMap(Map<String, dynamic> data) {
    return Project(
      title: data['title'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      initiatedBy: data['initiatedBy'] ?? '',
    );
  }
}
