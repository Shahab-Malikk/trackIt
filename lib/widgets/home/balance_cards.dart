import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/widgets/home/balance_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceCards extends StatelessWidget {
  const BalanceCards({super.key});

  @override
  Widget build(BuildContext context) {
    final financialData = Provider.of<FinancialData>(context);
    return Row(
      children: [
        BalanceCard(
          bgColor: TColors.white,
          textColor: TColors.lightGreen,
          title: "Balance",
          amount: financialData.totalBalance.toStringAsFixed(1),
          icon: Icons.trending_up_sharp,
        ),
        const SizedBox(width: 12),
        BalanceCard(
          bgColor: TColors.white,
          textColor: TColors.lightOrange,
          title: "Expenses",
          amount: financialData.totalExpenses.toStringAsFixed(1),
          icon: Icons.trending_down_sharp,
        ),
      ],
    );
  }
}
