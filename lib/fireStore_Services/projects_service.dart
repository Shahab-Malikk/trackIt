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
      'initiatedBy': project.initiatedBy,
      'description': project.description,
    });
  }

//Fetch Recent Projects
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
}
