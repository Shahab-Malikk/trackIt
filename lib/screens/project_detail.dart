import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/fireStore_Services/collaborated_project_service.dart';
import 'package:expense_tracker/fireStore_Services/expenses_service.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
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

    try {
      if (widget.project.projectType == "Personal") {
        final financialData =
            Provider.of<FinancialData>(context, listen: false);
        final totalExpenses = financialData.totalExpenses + expense.amount;
        financialData.updateTotalExpenses(totalExpenses);
        final balance = financialData.totalBalance - expense.amount;
        financialData.updateTotalIncome(balance);
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'expenses': totalExpenses,
          'balance': balance,
        });
        await ExpensesService(fireStoreService).storeExpenseOfProjectInDb(
            expense, widget.userId, widget.project.id);
      } else {
        List<String> collaborators =
            await CollaboratedProjectService(fireStoreService)
                .fetchCollaboratorsIds(widget.project.id);
        final amountPerCollaborator = expense.amount / (collaborators.length);
        print("Amount Per Collaborator: ");
        print(amountPerCollaborator);
        await CollaboratedProjectService(fireStoreService)
            .updateBalanceAndExpenseOfCollaborators(
                collaborators, amountPerCollaborator, "AddExpense");
        await CollaboratedProjectService(fireStoreService)
            .storeExpenseOfCollaboratedProjectInDb(
          widget.project.id,
          expense,
        );
      }
      if (context.mounted) {
        UtilityFunctions().showInfoMessage(
          "Expense Added Sucessfuly.",
          context,
        );
      }
    } catch (e) {
      UtilityFunctions().showInfoMessage("An error occured.", context);
    }
  }

  void _fetchAndStoreExpenses() async {
    List<Expense> expenses = [];
    if (widget.project.projectType == "Personal") {
      expenses = await ExpensesService(fireStoreService)
          .fetchExpensesOfCurrentProject(widget.userId, widget.project.id);
    } else {
      List<String> collaborators =
          await CollaboratedProjectService(fireStoreService)
              .fetchCollaboratorsIds(widget.project.id);
      print("Collaborators: ");
      print(collaborators);
      expenses = await CollaboratedProjectService(fireStoreService)
          .fetchExpensesOfCollaboratedProject(widget.project.id);
    }

    setState(() {
      _registeredExpenses = expenses;
    });
  }

  void _removeExpense(Expense expense) async {
    try {
      if (widget.project.projectType == "Personal") {
        final financialData =
            Provider.of<FinancialData>(context, listen: false);
        final totalExpenses = financialData.totalExpenses - expense.amount;
        financialData.updateTotalExpenses(totalExpenses);
        final balance = financialData.totalBalance + expense.amount;
        financialData.updateTotalIncome(balance);
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'expenses': totalExpenses,
          'balance': balance,
        });

        await ExpensesService(fireStoreService).deleteExpenseOfProject(
            widget.userId, widget.project.id, expense.id);
      } else {
        List<String> collaborators =
            await CollaboratedProjectService(fireStoreService)
                .fetchCollaboratorsIds(widget.project.id);
        final amountPerCollaborator = expense.amount / (collaborators.length);
        print("Amount Per Collaborator: ");
        print(amountPerCollaborator);
        await CollaboratedProjectService(fireStoreService)
            .updateBalanceAndExpenseOfCollaborators(
                collaborators, amountPerCollaborator, "RemoveExpense");
        await CollaboratedProjectService(fireStoreService)
            .deleteExpenseOfCollaboratedProject(widget.project.id, expense.id);
      }

      if (context.mounted) {
        UtilityFunctions().showInfoMessage(
          "Expense Deleted Sucessfuly.",
          context,
        );
      }
    } catch (e) {
      UtilityFunctions().showInfoMessage("An error occured.", context);
    }

    setState(() {
      _registeredExpenses.remove(expense);
    });
  }

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
                    Icon(widget.project.projectType == "Personal"
                        ? Icons.person
                        : Icons.people),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      widget.project.projectType,
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
                expenses: _registeredExpenses,
                onRemoveItem: _removeExpense,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
