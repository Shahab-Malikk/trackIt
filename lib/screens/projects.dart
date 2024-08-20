import 'package:expense_tracker/screens/project_detail.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/widgets/project_item.dart';
import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  void selectProject(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ProjectDetailScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          ProjectItem(
            onSelectProject: () {
              selectProject(context);
            },
          ),
        ],
      ),
    );
  }
}
