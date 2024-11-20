import 'package:expense_tracker/fireStore_Services/collaborated_project_service.dart';
import 'package:expense_tracker/fireStore_Services/projects_service.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/utils/utility_functions.dart';
import 'package:expense_tracker/widgets/utils/no_data.dart';
import 'package:expense_tracker/widgets/projects/projects_list.dart';
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
  //Function to remove project from recent projects
  void removeProject(Project project) {
    try {
      if (project.projectType == "Personal") {
        ProjectsService(fireStoreService)
            .deleteProject(widget.userId, project.id, context);
      } else {
        CollaboratedProjectService(fireStoreService)
            .deleteCollaboratedProject(project.id, context);
      }
      setState(() {
        widget.recentProjects.remove(project);
      });
      UtilityFunctions()
          .showInfoMessage("Project deleted successfuly.", context);
    } catch (e) {
      UtilityFunctions().showInfoMessage("Failed to delete project.", context);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Column(
      children: [
        widget.recentProjects.isNotEmpty
            ? const Text(
                "Here is list of recent projects, tap a project to view expenses.",
                style: TextStyle(fontSize: 16, color: Colors.black38),
              )
            : const SizedBox(),
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
      mainContent = const NoData(message: "No recent projects found.");
    }
    return Expanded(
      child: mainContent,
    );
  }
}
