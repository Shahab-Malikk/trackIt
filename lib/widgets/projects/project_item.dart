import 'package:cloud_firestore/cloud_firestore.dart';
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
                  const Spacer(),
                  // Wrap the total expenses with a StreamBuilder to listen for real-time updates
                  StreamBuilder<QuerySnapshot>(
                    stream: widget.project.projectType == "Personal"
                        ? ProjectsService(fireStoreService)
                            .streamProjectExpenses(
                                widget.userId, widget.project.id)
                        : CollaboratedProjectService(fireStoreService)
                            .streamProjectExpenses(widget.project.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error");
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      double total = 0.0;
                      if (snapshot.hasData) {
                        total =
                            snapshot.data!.docs.fold(0.0, (previousValue, doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final amount = data['amount'];
                          if (amount is int) {
                            return previousValue + amount.toDouble();
                          } else if (amount is double) {
                            return previousValue + amount;
                          } else if (amount is String) {
                            return previousValue +
                                (double.tryParse(amount) ?? 0.0);
                          }
                          return previousValue;
                        });
                      }

                      return Text(
                        total.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectProject(BuildContext context, Project project) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ProjectDetailScreen(
        project: project,
        userId: widget.userId,
      ),
    ));
  }
}
