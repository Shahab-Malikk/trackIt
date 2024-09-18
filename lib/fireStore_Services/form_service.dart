import 'package:firebase_database/firebase_database.dart';

class FormService {
  final DatabaseReference _formRef =
      FirebaseDatabase.instance.ref().child('forms').child('income_form');
  final DatabaseReference _authFormRef =
      FirebaseDatabase.instance.ref().child('forms').child('authForm');

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

  Future<List<Map<String, dynamic>>> fetchAuthFormData(String type) async {
    DatabaseEvent event = await _authFormRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      // Get the map containing both "signup" and "login" form data
      Map<String, dynamic> formData =
          Map<String, dynamic>.from(snapshot.value as Map);

      // Extract the specific form type (e.g., "signup" or "login") as a list
      List<dynamic> formTypeData = formData[type] as List<dynamic>;

      // Convert each item in the list to Map<String, dynamic>
      List<Map<String, dynamic>> formFields = formTypeData.map((item) {
        return Map<String, dynamic>.from(item as Map); // Ensures correct type
      }).toList();

      return formFields;
    }

    return [];
  }
}
