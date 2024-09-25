import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CollaboratedProjectService {
  final FirestoreServices _firestoreServices;

  CollaboratedProjectService(this._firestoreServices);

  CollectionReference get _collaboratedProjectsCollection =>
      _firestoreServices.db.collection('collaboratedProjects');

//Store Collaborated Project
  Future<void> storeCollaboratedProjectInDb(Project project) async {
    DocumentReference collaboratedProjectDoc =
        _collaboratedProjectsCollection.doc(project.id);

    return collaboratedProjectDoc.set({
      'id': project.id,
      'title': project.title,
      'date': project.date,
      'projectType': project.projectType,
      'description': project.description,
    });
  }

//Add Collaborator
  Future<void> addCollaborator(String projectId, String userId) async {
    DocumentReference collaboratedProjectDoc =
        _collaboratedProjectsCollection.doc(projectId);
    return collaboratedProjectDoc.update({
      'collaborators': FieldValue.arrayUnion([userId]),
    });
  }

  //Fetch Collaborators Ids

  Future<List<String>> fetchCollaboratorsIds(String projectId) async {
    DocumentSnapshot collaboratedProjectDoc =
        await _collaboratedProjectsCollection.doc(projectId).get();
    Map<String, dynamic>? data =
        collaboratedProjectDoc.data() as Map<String, dynamic>?;

    if (data != null) {
      List<String> collaboratorsIds = List<String>.from(data['collaborators']);
      return collaboratorsIds;
    } else {
      return [];
    }
  }

  Future<List<String>> fetchCollaboratorsNames(
      String projectId, String currentUserId) async {
    List<String> collaboratorsIds = await fetchCollaboratorsIds(projectId);
    List<String> collaboratorsNames = [];
    CollectionReference usersCollection =
        _firestoreServices.db.collection('users');
    for (String userId in collaboratorsIds) {
      DocumentSnapshot userDoc = await usersCollection.doc(userId).get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      if (userData != null) {
        if (userId != currentUserId) {
          String username = userData['userName'];
          username = username.split(" ")[0];
          collaboratorsNames.add(username);
        } else {
          collaboratorsNames.add("You");
        }
      }
    }

    return collaboratorsNames;
  }

//Fetch Collaborated Projects
  Future<List<Project>> fetchCollaboratedProjects(String userId) async {
    QuerySnapshot querySnapshot = await _collaboratedProjectsCollection
        .where('collaborators', arrayContains: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

//Store Expense of Collaborated Project
  Future<void> storeExpenseOfCollaboratedProjectInDb(
    String projectId,
    Expense expense,
  ) async {
    DocumentReference collaboratedProjectDoc =
        _collaboratedProjectsCollection.doc(projectId);

    return collaboratedProjectDoc
        .collection('expenses')
        .doc(expense.id)
        .set({
          'id': expense.id,
          'title': expense.title,
          'date': expense.date,
          'category': expense.category,
          'subCategory': expense.subCategory,
          'amount': expense.amount,
          'description': expense.description,
          'paidBy': expense.paidBy,
        })
        .then((value) => print("Expense Id"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //Remove Expense of Collaborated Project

  Future<void> deleteExpenseOfCollaboratedProject(
      String projectId, String expenseId) async {
    CollectionReference expenseCollection =
        _collaboratedProjectsCollection.doc(projectId).collection("expenses");
    return expenseCollection.doc(expenseId).delete().then((value) {
      print("Expense Deleted");
    }).catchError((error) {
      print("Failed to delete user: $error");
    });
  }

  // Fetch Expenses of Collaborated Project

  Future<List<Expense>> fetchExpensesOfCollaboratedProject(
      String projectId) async {
    CollectionReference expenseCollection =
        _collaboratedProjectsCollection.doc(projectId).collection("expenses");
    QuerySnapshot snapshot = await expenseCollection.get();
    return snapshot.docs
        .map((doc) => Expense.fromMap(
            doc.data() as Map<String, dynamic>)) // Extracting the 'name' field
        .toList();
  }

// Update Balance and Expenses of Collaborators
  Future<void> updateBalanceAndExpenseOfCollaborators(
      List<String> collaboratorsIds, double amount, String action) async {
    for (String userId in collaboratorsIds) {
      DocumentReference userDoc =
          _firestoreServices.db.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userDoc.get();

      // Ensure the data is properly cast to a Map
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        double balance = userData['balance'];
        double expenses = userData['expenses'];

        if (action == "AddExpense") {
          balance = balance - amount;
          expenses = expenses + amount;
        } else {
          balance = balance + amount;
          expenses = expenses - amount;
        }

        await userDoc.update({
          'balance': balance,
          'expenses': expenses,
        });
      }
    }
  }

  Future<List<double>> fetchTotalProjectExpenses(String projectId) async {
    List<String> collaboratorsIds = await fetchCollaboratorsIds(projectId);

    CollectionReference expenseCollection =
        _collaboratedProjectsCollection.doc(projectId).collection('expenses');

    QuerySnapshot snapshot = await expenseCollection.get();

    List<double> expenses = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['amount'] as double)
        .toList();

    List<double> updatedExpenses = expenses.map((expense) {
      return expense / collaboratorsIds.length;
    }).toList();

    return updatedExpenses;
  }

  Future<void> deleteCollaboratedProject(
      String projectId, BuildContext context) async {
    List<String> collaboratorsIds = await fetchCollaboratorsIds(projectId);
    List<double> expenses = await fetchTotalProjectExpenses(projectId);
    double totalExpenses = expenses.fold(0, (a, b) => a + b);
    final financialData = Provider.of<FinancialData>(context, listen: false);

    final updatedExpenses = financialData.totalExpenses - totalExpenses;
    financialData.updateTotalExpenses(updatedExpenses);
    final updatedBalance = financialData.totalBalance + totalExpenses;
    financialData.updateTotalIncome(updatedBalance);

    await updateBalanceAndExpenseOfCollaborators(
        collaboratorsIds, totalExpenses, "DeleteExpense");

    // delete expenses with in project

    await _collaboratedProjectsCollection
        .doc(projectId)
        .collection('expenses')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    return _collaboratedProjectsCollection
        .doc(projectId)
        .delete()
        .then((value) {
      print("Project Deleted");
    }).catchError((error) {
      print("Failed to delete user: $error");
    });
  }

  Stream<QuerySnapshot> streamProjectExpenses(String projectId) {
    return _collaboratedProjectsCollection
        .doc(projectId)
        .collection('expenses')
        .snapshots();
  }
}
