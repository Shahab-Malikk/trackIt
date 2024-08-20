import 'package:expense_tracker/models/expense.dart';
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
        key: ValueKey(index),
        background: Container(),
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
