import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  const ExpenseItem({super.key, required this.expense});

  String get categoryText {
    return expense.category[0].toUpperCase() + expense.category.substring(1);
  }

  String get subCategoryText {
    return expense.subCategory[0].toUpperCase() +
        expense.subCategory.substring(1);
  }

  String get expenseAmount {
    String formattedAmount = expense.amount.toStringAsFixed(2);
    return '-$formattedAmount';
  }

  @override
  Widget build(BuildContext context) {
    // final isDescriptionNotNull = expense.description.trim() != '';
    final isPaidbyNameNotNull = expense.paidBy.trim() != '';

    return Card(
      color: TColors.white,
      elevation: 1,
      child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    expense.formattedDate,
                    style: const TextStyle(
                      color: TColors.darkGrey,
                      fontSize: TSizes.fontSizeMd,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.category_outlined),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(categoryText)
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.category_rounded),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(subCategoryText)
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    expenseAmount,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: TColors.lightOrange,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  if (isPaidbyNameNotNull)
                    Text(
                      expense.paidBy,
                      style: const TextStyle(
                          fontSize: TSizes.fontSizeMd,
                          fontWeight: FontWeight.w500,
                          color: TColors.darkGrey),
                    ),
                ],
              )
            ],
          )),
    );
  }
}
