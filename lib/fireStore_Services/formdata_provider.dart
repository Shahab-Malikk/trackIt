import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert'; // To convert JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For network requests

class FormDataProvider {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> fetchFormData() async {
    try {
      // Get the download URL for the expense_form.json file
      final ref = _storage.ref().child('forms/expense_form.json');
      final String downloadURL = await ref.getDownloadURL();

      // Fetch the file content from the download URL
      final response = await http.get(Uri.parse(downloadURL));

      if (response.statusCode == 200) {
        // Decode JSON data from the response
        List<dynamic> jsonData = json.decode(response.body);

        // Convert dynamic List to List<Map<String, dynamic>>
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load form data');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
