import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/user_data_service.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesScreen extends StatefulWidget {
  final String userId;
  final List<Expense> registeredExpenses;
  ExpensesScreen({required this.userId, required this.registeredExpenses});
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
        userId: widget.userId,
      ),
    );
  }

  void _addExpense(Expense expense) async {
    setState(() {
      widget.registeredExpenses.add(expense);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final financialData = Provider.of<FinancialData>(context, listen: false);
      final totalExpenses = widget.registeredExpenses
          .fold(0.0, (sum, expense) => sum + expense.amount);
      financialData.updateTotalExpenses(totalExpenses);
      final balance = financialData.totalBalance - expense.amount;
      financialData.updateTotalIncome(balance);
      FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'expenses': totalExpenses,
        'balance': balance,
      });
    });

    try {
      await UserDataService(fireStoreService)
          .storeExpenseInDb(expense, widget.userId);
      if (context.mounted) {
        _showInfoMessage("Expense Added Successfully");
      }
    } catch (e) {
      _showInfoMessage("An error occured.");
    }
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _removeExpense(Expense expense) {
    setState(() {
      widget.registeredExpenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      floatingActionButton: Tooltip(
        message: "Add Expense",
        decoration: BoxDecoration(
          color: Colors.black87, // Background color of the tooltip
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white, // Text color
        ),
        waitDuration:
            const Duration(milliseconds: 500), // Time before tooltip appears
        showDuration:
            const Duration(seconds: 2), // How long the tooltip is shown
        child: FloatingActionButton(
          backgroundColor: TColors.black,
          onPressed: _openAddExpenseOverlay,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          child: const Icon(
            Icons.add,
            size: 46,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Expenses(
          expenses: widget.registeredExpenses,
          onRemoveItem: _removeExpense,
        ),
      ),
    );
  }
}
