import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';

class CollaboratedProjectService {
  final FirestoreServices _firestoreServices;

  CollaboratedProjectService(this._firestoreServices);

  CollectionReference get _collaboratedProjectsCollection =>
      _firestoreServices.db.collection('collaboratedProjects');

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

  Future<void> addCollaborator(String projectId, String userId) async {
    DocumentReference collaboratedProjectDoc =
        _collaboratedProjectsCollection.doc(projectId);
    return collaboratedProjectDoc.update({
      'collaborators': FieldValue.arrayUnion([userId]),
    });
  }

  Future<List<Project>> fetchCollaboratedProjects(String userId) async {
    QuerySnapshot querySnapshot = await _collaboratedProjectsCollection
        .where('collaborators', arrayContains: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Fetch collaborators
}
