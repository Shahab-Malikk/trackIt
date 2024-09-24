import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/widgets/no_data.dart';
import 'package:expense_tracker/widgets/projects_list.dart';
import 'package:flutter/material.dart';

class RecentProjects extends StatelessWidget {
  final List<Project> recentProjects;
  final String userId;
  const RecentProjects({
    super.key,
    required this.recentProjects,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Column(
      children: [
        const Text(
          "Here are your recent projects , see all projects by navigating to Projects.",
          style: TextStyle(fontSize: 16, color: Colors.black38),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ProjectsList(
            projects: recentProjects,
            userId: userId,
            deleteProject: (project) {
              recentProjects.remove(project);
            },
          ),
        ),
      ],
    );

    if (recentProjects.isEmpty) {
      mainContent = const NoData(message: "Add Projects to track expenses.");
    }
    return Expanded(
      child: mainContent,
    );
  }
}
