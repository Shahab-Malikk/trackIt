import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';

class ProjectsService {
  final FirestoreServices _fireStoreServices;

  ProjectsService(this._fireStoreServices);

  CollectionReference get _usersCollection =>
      _fireStoreServices.db.collection('users');

//Store Project in Database

  Future<void> storeProjectInDb(Project project, String userId) {
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("projects");

    return projectsCollection.doc(project.id).set({
      'id': project.id,
      'title': project.title,
      'date': project.date,
      'projectType': project.projectType,
      'description': project.description,
    });
  }

//Fetch Recent Projects
  Future<List<Project>> fetchRecentProjects(String userId) async {
    // Fetch Individual Projects
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("projects");
    QuerySnapshot querySnapshot = await projectsCollection
        .orderBy('date', descending: true)
        .limit(3)
        .get();

    List<Project> individualProjects = querySnapshot.docs.map((doc) {
      return Project.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    // Fetch Collaborated Projects
    CollectionReference collaboratedProjectsCollection =
        _fireStoreServices.db.collection('collaboratedProjects');

    QuerySnapshot querySnapshotCollaboratedProjects =
        await collaboratedProjectsCollection
            .where('collaborators', arrayContains: userId)
            .orderBy('date', descending: true)
            .limit(3)
            .get();

    List<Project> collaboratedProjects =
        querySnapshotCollaboratedProjects.docs.map((doc) {
      return Project.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    // return querySnapshot.docs
    //     .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
    //     .toList();

//Merging projects to get top 3 recent projects
    List<Project> allProjects = [
      ...individualProjects,
      ...collaboratedProjects
    ];
    allProjects.sort((a, b) => b.date.compareTo(a.date));

    //Get top 3 recent projects from all projects
    return allProjects.take(3).toList();
  }

//Fetch all  Projects
  Future<List<Project>> fetchProjects(String userId) async {
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("projects");
    QuerySnapshot snapshot = await projectsCollection.get();

    return snapshot.docs
        .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<double>> fetchTotalProjectExpenses(
      String userId, String projectId) async {
    CollectionReference expenseCollection = _usersCollection
        .doc(userId)
        .collection("projects")
        .doc(projectId)
        .collection('expenses');

    QuerySnapshot snapshot = await expenseCollection.get();

    List<double> expenses = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['amount'] as double)
        .toList();
    return expenses;
  }

  Stream<QuerySnapshot> streamProjectExpenses(String userId, String projectId) {
    return _usersCollection
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .collection('expenses')
        .snapshots();
  }
}
