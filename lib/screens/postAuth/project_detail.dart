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
import 'package:expense_tracker/widgets/expenses/collaborator_item.dart';
import 'package:expense_tracker/widgets/expenses/expenses.dart';
import 'package:expense_tracker/widgets/expenses/new_expense.dart';
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
  List<String> collaborators = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAndStoreExpenses();
    print(widget.project.id);
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
        await _handlePersonalProjectExpense(expense);
      } else {
        await _handleCollaboratedProjectExpense(expense);
      }

      if (context.mounted) {
        UtilityFunctions().showInfoMessage(
          "Expense Added Successfully.",
          context,
        );
      }
    } catch (e) {
      UtilityFunctions().showInfoMessage("An error occurred.", context);
    }
  }

  Future<void> _handlePersonalProjectExpense(Expense expense) async {
    final financialData = Provider.of<FinancialData>(context, listen: false);

    // Update total expenses and balance
    final totalExpenses = financialData.totalExpenses + expense.amount;
    final balance = financialData.totalBalance - expense.amount;

    // Update FinancialData and Firestore
    financialData.updateTotalExpenses(totalExpenses);
    financialData.updateTotalIncome(balance);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({
      'expenses': totalExpenses,
      'balance': balance,
    });

    // Store expense in Firestore for the project
    await ExpensesService(fireStoreService)
        .storeExpenseOfProjectInDb(expense, widget.userId, widget.project.id);
  }

  Future<void> _handleCollaboratedProjectExpense(Expense expense) async {
    final collaborators = await CollaboratedProjectService(fireStoreService)
        .fetchCollaboratorsIds(widget.project.id);

    final amountPerCollaborator = expense.amount / collaborators.length;
    final financialData = Provider.of<FinancialData>(context, listen: false);

    // Update total expenses and balance for collaborators
    final totalExpenses = financialData.totalExpenses + amountPerCollaborator;
    final balance = financialData.totalBalance - amountPerCollaborator;

    financialData.updateTotalExpenses(totalExpenses);
    financialData.updateTotalIncome(balance);

    // Update balance and expenses for each collaborator in Firestore
    await CollaboratedProjectService(fireStoreService)
        .updateBalanceAndExpenseOfCollaborators(
            collaborators, amountPerCollaborator, "AddExpense");

    // Store expense in Firestore for the collaborated project
    await CollaboratedProjectService(fireStoreService)
        .storeExpenseOfCollaboratedProjectInDb(widget.project.id, expense);
  }

  void _fetchAndStoreExpenses() async {
    List<Expense> expenses = [];
    if (widget.project.projectType == "Personal") {
      expenses = await ExpensesService(fireStoreService)
          .fetchExpensesOfCurrentProject(widget.userId, widget.project.id);
    } else {
      collaborators = await CollaboratedProjectService(fireStoreService)
          .fetchCollaboratorsNames(widget.project.id, widget.userId);

      expenses = await CollaboratedProjectService(fireStoreService)
          .fetchExpensesOfCollaboratedProject(widget.project.id);
    }

    setState(() {
      _registeredExpenses = expenses;
      _isLoading = false;
    });
  }

  void _removeExpense(Expense expense) async {
    try {
      if (widget.project.projectType == "Personal") {
        await _removePersonalExpense(expense);
      } else {
        await _removeCollaboratedExpense(expense);
      }

      showMessage("Expense Deleted Successfully.");

      setState(() {
        _registeredExpenses.remove(expense);
      });
    } catch (e) {
      showMessage("An error occurred.");
    }
  }

// Method to remove personal expense
  Future<void> _removePersonalExpense(Expense expense) async {
    final financialData = Provider.of<FinancialData>(context, listen: false);
    final totalExpenses = financialData.totalExpenses - expense.amount;
    final updatedBalance = financialData.totalBalance + expense.amount;

    // Update local financial data
    financialData.updateTotalExpenses(totalExpenses);
    financialData.updateTotalIncome(updatedBalance);

    // Update Firestore with new total expenses and balance
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({
      'expenses': totalExpenses,
      'balance': updatedBalance,
    });

    // Remove the expense from Firestore
    await ExpensesService(fireStoreService)
        .deleteExpenseOfProject(widget.userId, widget.project.id, expense.id);
  }

// Method to remove collaborated project expense
  Future<void> _removeCollaboratedExpense(Expense expense) async {
    final collaborators = await _getCollaborators(widget.project.id);
    final amountPerCollaborator = expense.amount / collaborators.length;

    final financialData = Provider.of<FinancialData>(context, listen: false);
    final totalExpenses = financialData.totalExpenses - amountPerCollaborator;
    final updatedBalance = financialData.totalBalance + amountPerCollaborator;

    // Update local financial data
    financialData.updateTotalExpenses(totalExpenses);
    financialData.updateTotalIncome(updatedBalance);

    // Update the balances and expenses for each collaborator
    await CollaboratedProjectService(fireStoreService)
        .updateBalanceAndExpenseOfCollaborators(
            collaborators, amountPerCollaborator, "RemoveExpense");

    // Remove the expense from the collaborated project
    await CollaboratedProjectService(fireStoreService)
        .deleteExpenseOfCollaboratedProject(widget.project.id, expense.id);
  }

// Helper method to get collaborators of a project
  Future<List<String>> _getCollaborators(String projectId) async {
    return await CollaboratedProjectService(fireStoreService)
        .fetchCollaboratorsIds(projectId);
  }

// General method to show any message
  void showMessage(String message) {
    if (context.mounted) {
      UtilityFunctions().showInfoMessage(message, context);
    }
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
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    height: 20,
                  ),
                  if (collaborators.isNotEmpty)
                    Column(
                      children: [
                        const Text(
                          "Collaborators",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 8.0, // Adds spacing between collaborators
                          runSpacing: 8.0, // Adds spacing between rows
                          children: [
                            for (var i = 0; i < collaborators.length; i++)
                              CollaboratorItem(
                                collaboratorName: collaborators[i],
                              ),
                          ],
                        )
                      ],
                    ),
                  const Text(
                    "Expenses List",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
