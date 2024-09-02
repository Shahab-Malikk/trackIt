import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class IncomeItem extends StatelessWidget {
  final Income income;
  const IncomeItem({super.key, required this.income});

  @override
  Widget build(BuildContext context) {
    final isPaidbyNameNotNull = income.paidBy.trim() != '';
    return Card(
      color: TColors.white,
      elevation: 1,
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
                  income.amount.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: TColors.lightGreen,
                  ),
                ),
                const Spacer(),
                if (isPaidbyNameNotNull)
                  Row(
                    children: [
                      const Icon(Icons.person_2_outlined),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        income.paidBy,
                        style: const TextStyle(
                          fontSize: TSizes.fontSizeMd,
                          color: TColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              income.formattedDate,
              style: const TextStyle(
                color: TColors.darkGrey,
                fontSize: TSizes.fontSizeMd,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              income.description,
              style: const TextStyle(
                fontSize: TSizes.fontSizeMd,
                color: TColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
