import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  final List<Expense> expenses;
  const Expenses(
      {super.key, required this.expenses, required this.onRemoveItem});
  final void Function(Expense expense) onRemoveItem;
  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        'No expenses available',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    if (widget.expenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: widget.expenses,
        deletExpnese: widget.onRemoveItem,
      );
    }
    return Column(
      children: [
        Expanded(child: mainContent),
      ],
    );
  }
}
