import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/user_data_service.dart';
import 'package:expense_tracker/utils/utility_functions.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  final String userId;
  const ProjectDetailScreen(
      {super.key, required this.project, required this.userId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  List<Expense> _registeredExpenses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAndStoreExpenses();
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
        userId: widget.userId,
        projectId: widget.project.id,
      ),
    );
  }

  void _addExpense(Expense expense) async {
    setState(() {
      _registeredExpenses.add(expense);
    });

    final financialData = Provider.of<FinancialData>(context, listen: false);
    final totalExpenses = financialData.totalExpenses + expense.amount;
    financialData.updateTotalExpenses(totalExpenses);
    final balance = financialData.leftBalance - expense.amount;
    financialData.updateTotalIncome(balance);
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'expenses': totalExpenses,
      'balance': balance,
    });
    try {
      await UserDataService(fireStoreService)
          .storeExpenseOfProjectInDb(expense, widget.userId, widget.project.id);
      if (context.mounted) {
        UtilityFunctions().showInfoMessage(
          "Expense Added Sucessfuly.",
          context,
        );
      }
    } catch (e) {
      UtilityFunctions().showInfoMessage("An error occured.", context);
      print(e);
    }
  }

  void _fetchAndStoreExpenses() async {
    final List<Expense> expenses = await UserDataService(fireStoreService)
        .fetchExpensesOfCurrentProject(widget.userId, widget.project.id);
    setState(() {
      _registeredExpenses = expenses;
    });
  }

  void _removeExpense(Expense expense) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
      ),
      floatingActionButton: Tooltip(
        message: "Add Project",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.project.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.project.description,
              style: const TextStyle(
                fontSize: TSizes.fontSizeMd,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      widget.project.formattedDate,
                      style: const TextStyle(
                        fontSize: TSizes.fontSizeMd,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.person_2_outlined),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      widget.project.initiatedBy,
                      style: const TextStyle(
                        fontSize: TSizes.fontSizeMd,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Expenses List",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Expenses(
                  expenses: _registeredExpenses, onRemoveItem: _removeExpense),
            ),
          ],
        ),
      ),
    );
  }
}
