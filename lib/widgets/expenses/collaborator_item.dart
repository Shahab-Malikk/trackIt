import 'package:flutter/material.dart';

class CollaboratorItem extends StatelessWidget {
  final String collaboratorName;
  const CollaboratorItem({super.key, required this.collaboratorName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.person,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          collaboratorName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
