import 'package:firebase_database/firebase_database.dart';

class FormService {
  final DatabaseReference _formRef =
      FirebaseDatabase.instance.ref().child('forms').child('income_form');

  Future<List<Map<String, dynamic>>> fetchFormData() async {
    DatabaseEvent event = await _formRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      // Try casting the fetched data to List<dynamic>
      List<dynamic> formData = snapshot.value as List<dynamic>;

      // Convert each item in the list to Map<String, dynamic>
      List<Map<String, dynamic>> formFields = formData.map((item) {
        return Map<String, dynamic>.from(
            item as Map); // This ensures the correct type is used
      }).toList();

      return formFields;
    }

    return [];
  }
}
