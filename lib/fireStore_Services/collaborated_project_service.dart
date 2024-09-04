import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';

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
      List<String> collaboratorsIds, double amount) async {
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

        balance = balance - amount;
        expenses = expenses + amount;

        await userDoc.update({
          'balance': balance,
          'expenses': expenses,
        });
      }
    }
  }
}
