import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Project {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final String projectType;

  Project({
    required this.title,
    required this.date,
    required this.description,
    required this.id,
    this.projectType = 'project',
  });

  String get formattedDate {
    return formatter.format(date);
  }

  factory Project.fromMap(Map<String, dynamic> data) {
    return Project(
        id: data['id'],
        title: data['title'] ??
            '', // If the title is not present, default to an empty string
        date: (data['date'] as Timestamp)
            .toDate(), // Convert the Timestamp to a DateTime
        description: data['description'] ??
            '', // If the description is not present, default to an empty string
        projectType: data['projectType'] ??
            '' // If the projectType is not present, default to 'project'
        );
  }
}
