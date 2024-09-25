import 'package:expense_tracker/fireStore_Services/projects_service.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/widgets/no_data.dart';
import 'package:expense_tracker/widgets/projects_list.dart';
import 'package:flutter/material.dart';

class RecentProjects extends StatefulWidget {
  final List<Project> recentProjects;
  final String userId;
  const RecentProjects({
    super.key,
    required this.recentProjects,
    required this.userId,
  });

  @override
  State<RecentProjects> createState() => _RecentProjectsState();
}

class _RecentProjectsState extends State<RecentProjects> {
  void removeProject(Project project) {
    setState(() {
      widget.recentProjects.remove(project);
    });
    try {
      if (project.projectType == "Personal") {
        ProjectsService(fireStoreService)
            .deleteProject(widget.userId, project.id, context);
      }
    } catch (e) {
      print(e);
    }
  }

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
            projects: widget.recentProjects,
            userId: widget.userId,
            deleteProject: (project) {
              removeProject(project);
            },
          ),
        ),
      ],
    );

    if (widget.recentProjects.isEmpty) {
      mainContent = const NoData(message: "Add Projects to track expenses.");
    }
    return Expanded(
      child: mainContent,
    );
  }
}
