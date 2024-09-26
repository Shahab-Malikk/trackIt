import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/widgets/reconcilation/income_item.dart';
import 'package:expense_tracker/widgets/utils/no_data.dart';
import 'package:flutter/material.dart';

class IncomeRecords extends StatelessWidget {
  final List<Income> incomeRecords;
  const IncomeRecords({super.key, required this.incomeRecords});

  @override
  Widget build(BuildContext context) {
    if (incomeRecords.isNotEmpty) {
      // If there are projects, show the list
      return ListView.builder(
        itemCount: incomeRecords.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(index),
          background: Container(),
          child: IncomeItem(
            income: incomeRecords[index],
          ),
        ),
      );
    } else {
      // If there are no projects, show the NoData widget centered
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            NoData(
              message: "No Income Record",
            ),
          ],
        ),
      );
    }
  }
}
