import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class WlecomeBanner extends StatelessWidget {
  final String userName;
  const WlecomeBanner({super.key, required this.userName});

  get firstLetterofName => userName[0].toUpperCase();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 35,
            child: ClipOval(
              child: Container(
                color: TColors.darkGrey,
                child: Center(
                  child: Text(
                    firstLetterofName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 14, color: Colors.black38),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(userName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
