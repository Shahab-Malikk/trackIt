import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

class Project {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final String intiatedBy;

  Project({
    required this.title,
    required this.date,
    required this.description,
    required this.intiatedBy,
  }) : id = uuid.v4();
}
