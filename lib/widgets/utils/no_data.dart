import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String message;
  const NoData({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/noData.png',
          width: 200,
          height: 200,
        ),
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black38),
        )
      ],
    );
  }
}
