import 'package:expense_tracker/fireStore_Services/collaborated_project_service.dart';
import 'package:expense_tracker/fireStore_Services/projects_service.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/screens/project_detail.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class ProjectItem extends StatefulWidget {
  final Project project;
  final String userId;
  const ProjectItem({
    super.key,
    required this.project,
    required this.userId,
  });

  @override
  State<ProjectItem> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  double projectTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchProjectTotal();
  }

  void _fetchProjectTotal() async {
    double total = 0.0;
    List<double> amounts = widget.project.projectType == "Personal"
        ? await ProjectsService(fireStoreService)
            .fetchTotalProjectExpenses(widget.userId, widget.project.id)
        : await CollaboratedProjectService(fireStoreService)
            .fetchTotalProjectExpenses(widget.project.id);

    amounts.forEach((amount) {
      total += amount;
    });
    setState(() {
      projectTotal = total;
    });
  }

  void selectProject(BuildContext context, Project project) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ProjectDetailScreen(
        project: project,
        userId: widget.userId,
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
          selectProject(context, widget.project);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.project.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${projectTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.project.description,
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
                        widget.project.formattedDate,
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
                        widget.project.projectType == 'Personal'
                            ? Icons.person
                            : Icons.people,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        widget.project.projectType,
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
