import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/widgets/project_item.dart';
import 'package:flutter/material.dart';

class ProjectsList extends StatelessWidget {
  final List<Project> projects;
  final String userId;
  const ProjectsList({
    super.key,
    required this.projects,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(index),
        background: Container(),
        child: ProjectItem(
          project: projects[index],
          userId: userId,
        ),
      ),
    );
  }
}
