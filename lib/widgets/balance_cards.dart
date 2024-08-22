import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceCards extends StatelessWidget {
  const BalanceCards({super.key});

  @override
  Widget build(BuildContext context) {
    final financialData = Provider.of<FinancialData>(context);
    return Row(
      children: [
        Expanded(
          child: Card(
            color: TColors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_sharp,
                    size: TSizes.iconLg,
                    color: TColors.lightGreen,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        financialData.totalBalance.toStringAsFixed(1),
                        style: const TextStyle(
                            color: TColors.lightGreen,
                            fontSize: 22,
                            fontWeight: FontWeight.w900),
                      ),
                      const Text(
                        'Balance',
                        style: TextStyle(
                            color: TColors.dark, fontSize: TSizes.fontSizeLg),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: TColors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_down_sharp,
                    size: TSizes.iconLg,
                    color: TColors.lightOrange,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        financialData.totalExpenses.toStringAsFixed(1),
                        style: const TextStyle(
                            color: TColors.lightOrange,
                            fontSize: 22,
                            fontWeight: FontWeight.w900),
                      ),
                      const Text(
                        'Expenses',
                        style: TextStyle(
                            color: TColors.dark, fontSize: TSizes.fontSizeLg),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ), // Spacing between the cards
      ],
    );
  }
}
