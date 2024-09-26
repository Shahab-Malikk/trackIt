import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/widgets/utils/no_data.dart';
import 'package:expense_tracker/widgets/projects/project_item.dart';
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
          background: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              color: TColors.error.withOpacity(0.1),
              elevation: 1,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.delete,
                      color: TColors.error,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: TColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          direction: DismissDirection
              .endToStart, // Only allow dismissal from right to left
          onDismissed: (direction) {
            deleteProject(projects[index]);
          },
          key: ValueKey(projects[index].id),
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
