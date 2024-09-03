import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/screens/project_detail.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class ProjectItem extends StatelessWidget {
  final Project project;
  final String userId;
  const ProjectItem({
    super.key,
    required this.project,
    required this.userId,
  });

  void selectProject(BuildContext context, Project project) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ProjectDetailScreen(
        project: project,
        userId: userId,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TColors.white,
      elevation: 1,
      child: InkWell(
        onTap: () {
          selectProject(context, project);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                project.description,
                style: const TextStyle(
                  fontSize: TSizes.fontSizeMd,
                  color: TColors.darkGrey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        project.formattedDate,
                        style: const TextStyle(
                          fontSize: TSizes.fontSizeMd,
                          color: TColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        project.projectType == 'Personal'
                            ? Icons.person
                            : Icons.people,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        project.projectType,
                        style: const TextStyle(
                          fontSize: TSizes.fontSizeMd,
                          color: TColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
