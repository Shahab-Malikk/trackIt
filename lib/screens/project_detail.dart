import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project 1 "),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
