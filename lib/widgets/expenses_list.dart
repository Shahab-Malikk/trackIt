import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense expense) deletExpnese;
  const ExpensesList(
      {super.key, required this.expenses, required this.deletExpnese});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(expenses[index].id),
        background: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Card(
            color: TColors.error.withOpacity(0.1),
            elevation: 1,
            child: const Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.delete,
                    color: TColors.error,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: TColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        child: ExpenseItem(
          expense: expenses[index],
        ),
        onDismissed: (direction) => {
          deletExpnese(expenses[index]),
        },
      ),
    );
  }
}
