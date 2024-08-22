import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';

class UserDataService {
  final FirestoreServices _firestoreService;

  UserDataService(this._firestoreService);

  CollectionReference get _usersCollection =>
      _firestoreService.db.collection('users');

  Future<void> storeProjectInDb(Project project, String userId) {
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("projects");

    return projectsCollection.doc(project.id).set({
      'id': project.id,
      'title': project.title,
      'date': project.date,
      'initiatedBy': project.initiatedBy,
      'description': project.description,
    });
  }

  Future<List<Project>> fetchRecentProjects(String userId) async {
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("projects");
    QuerySnapshot querySnapshot = await projectsCollection
        .orderBy('date', descending: true)
        .limit(3)
        .get();

    return querySnapshot.docs
        .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Project>> fetchProjects(String userId) async {
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("projects");
    QuerySnapshot snapshot = await projectsCollection.get();

    return snapshot.docs
        .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Expense>> fetchExpensesOfCurrentProject(
      String userId, String projectId) async {
    CollectionReference expenseCollection = _usersCollection
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection("expenses");
    QuerySnapshot snapshot = await expenseCollection.get();
    return snapshot.docs
        .map((doc) => Expense.fromMap(
            doc.data() as Map<String, dynamic>)) // Extracting the 'name' field
        .toList();
  }

  Future<List<Expense>> fetchExpenses(String userId) async {
    CollectionReference expenseCollection =
        _usersCollection.doc(userId).collection('expenses');
    QuerySnapshot snapshot = await expenseCollection.get();
    return snapshot.docs
        .map((doc) => Expense.fromMap(
            doc.data() as Map<String, dynamic>)) // Extracting the 'name' field
        .toList();
  }

  Future<void> storeExpenseInDb(Expense expense, String userId) {
    CollectionReference expenseCollection =
        _usersCollection.doc(userId).collection('expenses');

    return expenseCollection
        .add({
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

  Future<void> storeExpenseOfProjectInDb(
      Expense expense, String userId, String projectId) {
    CollectionReference expenseCollection = _usersCollection
        .doc(userId)
        .collection("projects")
        .doc(projectId)
        .collection("expenses");

    return expenseCollection
        .add({
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
}
