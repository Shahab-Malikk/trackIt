import 'package:expense_tracker/fireStore_Services/collaborated_project_service.dart';
import 'package:expense_tracker/fireStore_Services/projects_service.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/screens/project_type.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/utils/utility_functions.dart';
import 'package:expense_tracker/widgets/projects_list.dart';
import 'package:flutter/material.dart';

class ProjectsScreen extends StatefulWidget {
  final String userId;
  const ProjectsScreen({super.key, required this.userId});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> projects = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProjectsFromDb();
  }

  void _openAddProjectOverlay() {
    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   context: context,
    //   builder: (ctx) => NewProject(
    //     onAddProject: _addProject,
    //   ),
    // );

    //Push to Project Type Selection Screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProjectTypeSelectionScreen(
          onAddProject: _addProject,
        ),
      ),
    );
  }

  void _addProject(Project project) async {
    setState(() {
      projects.add(project);
    });

    try {
      if (project.projectType == "Personal") {
        await ProjectsService(fireStoreService).storeProjectInDb(
          project,
          widget.userId,
        );
      } else {
        await CollaboratedProjectService(fireStoreService)
            .storeCollaboratedProjectInDb(project);
        await CollaboratedProjectService(fireStoreService).addCollaborator(
          project.id,
          widget.userId,
        );
      }

      if (context.mounted) {
        UtilityFunctions().showInfoMessage(
          "Project Added Successfuly.",
          context,
        );
      }
    } catch (e) {
      UtilityFunctions().showInfoMessage(
        "An error occured.",
        context,
      );
    }
  }

  void _fetchProjectsFromDb() async {
    try {
      List<Project> projectsFromDb =
          await ProjectsService(fireStoreService).fetchProjects(widget.userId);

      final List<Project> collaboratedProjectsFromDb =
          await CollaboratedProjectService(fireStoreService)
              .fetchCollaboratedProjects(widget.userId);
      if (context.mounted) {
        setState(() {
          projects = [...projectsFromDb, ...collaboratedProjectsFromDb];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Tooltip(
        message: "Add Project",
        decoration: BoxDecoration(
          color: Colors.black87, // Background color of the tooltip
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white, // Text color
        ),
        waitDuration:
            const Duration(milliseconds: 500), // Time before tooltip appears
        showDuration:
            const Duration(seconds: 2), // How long the tooltip is shown
        child: FloatingActionButton(
          backgroundColor: TColors.black,
          onPressed: _openAddProjectOverlay,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          child: const Icon(
            Icons.add,
            size: 46,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Add Your projects here.",
              style: TextStyle(
                fontSize: TSizes.fontSizeMd,
                color: TColors.black,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ProjectsList(
                projects: projects,
                userId: widget.userId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
