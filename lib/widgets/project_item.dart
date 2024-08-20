import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class ProjectItem extends StatelessWidget {
  final void Function() onSelectProject;
  const ProjectItem({super.key, required this.onSelectProject});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TColors.white,
      elevation: 1,
      child: InkWell(
        onTap: onSelectProject,
        child: const Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Project 1",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Here is my project 1 in this project. This project is about a new house.",
                style: TextStyle(
                  fontSize: TSizes.fontSizeMd,
                  color: TColors.darkGrey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "20/8/2024",
                        style: TextStyle(
                          fontSize: TSizes.fontSizeMd,
                          color: TColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.person_2_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "Watto Khan",
                        style: TextStyle(
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
