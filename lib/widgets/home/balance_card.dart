import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final String amount;
  final String title;
  const BalanceCard({
    super.key,
    required this.bgColor,
    required this.textColor,
    required this.title,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Balance card to show the total balance and expenses
    return Expanded(
      child: Card(
        color: bgColor,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Icon(
                icon,
                size: TSizes.iconLg,
                color: textColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: TColors.dark,
                      fontSize: TSizes.fontSizeLg,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
