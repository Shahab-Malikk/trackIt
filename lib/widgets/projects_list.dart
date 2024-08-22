import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/widgets/no_data.dart';
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
    if (projects.isNotEmpty) {
      // If there are projects, show the list
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
    } else {
      // If there are no projects, show the NoData widget centered
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: const [
            NoData(
              message: "Add projects to track expenses",
            ),
          ],
        ),
      );
    }
  }
}
