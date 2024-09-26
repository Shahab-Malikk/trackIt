import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses/expenses_list.dart';
import 'package:expense_tracker/widgets/utils/no_data.dart';
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
      child: NoData(message: "No Expenses found, Add expenses."),
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
