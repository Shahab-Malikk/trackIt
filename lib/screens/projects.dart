import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: const Column(
        children: [
          Text(
            "Add Your projects here.",
            style: TextStyle(
              fontSize: TSizes.fontSizeMd,
              color: TColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
