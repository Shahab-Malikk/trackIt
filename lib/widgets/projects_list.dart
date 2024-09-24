import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/widgets/no_data.dart';
import 'package:expense_tracker/widgets/project_item.dart';
import 'package:flutter/material.dart';

class ProjectsList extends StatelessWidget {
  final List<Project> projects;
  final String userId;
  final void Function(Project project) deleteProject;
  const ProjectsList({
    super.key,
    required this.projects,
    required this.userId,
    required this.deleteProject,
  });

  @override
  Widget build(BuildContext context) {
    if (projects.isNotEmpty) {
      // If there are projects, show the list
      return ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) => Dismissible(
          onDismissed: (direction) => deleteProject(projects[index]),
          key: ValueKey(projects[index].id),
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
          children: [
            NoData(
              message: "Add projects to track expenses",
            ),
          ],
        ),
      );
    }
  }
}
