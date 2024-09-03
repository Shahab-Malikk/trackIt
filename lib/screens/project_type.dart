import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/widgets/new_project.dart';
import 'package:expense_tracker/widgets/project_type_card.dart';
import 'package:flutter/material.dart';

class ProjectTypeSelectionScreen extends StatefulWidget {
  final Function(Project) onAddProject;
  const ProjectTypeSelectionScreen({super.key, required this.onAddProject});

  @override
  State<ProjectTypeSelectionScreen> createState() =>
      _ProjectTypeSelectionScreenState();
}

class _ProjectTypeSelectionScreenState
    extends State<ProjectTypeSelectionScreen> {
  void _openAddProjectOverlay(String projectType) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewProject(
        onAddProject: widget.onAddProject,
        projectType: projectType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Project Type'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                ProjectTypeCard(
                  title: 'Personal',
                  description: 'Manage your personal expenses',
                  icon: Icons.person,
                  onTap: () {
                    _openAddProjectOverlay('Personal');
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ProjectTypeCard(
                  title: 'Collaborative',
                  description: 'Manage expenses with your friends',
                  icon: Icons.people,
                  onTap: () {
                    _openAddProjectOverlay('Collaborative');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
