import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/income.dart';

class IncomeSrvice {
  final FirestoreServices _firestoreService;

  IncomeSrvice(this._firestoreService);

  CollectionReference get _usersCollection =>
      _firestoreService.db.collection('users');

//Store Income Record

  Future<void> storeIncomeInDb(Income income, String userId) {
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("income");

    return projectsCollection.doc(income.id).set(
      {
        'id': income.id,
        'date': income.date,
        'paidBy': income.paidBy,
        'description': income.description,
        'amount': income.amount,
      },
    );
  }

  //Fetch Income Record

  Future<List<Income>> fetchIncomeRecord(String userId) async {
    CollectionReference projectsCollection =
        _usersCollection.doc(userId).collection("income");
    QuerySnapshot querySnapshot = await projectsCollection.get();

    return querySnapshot.docs
        .map((doc) => Income.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
