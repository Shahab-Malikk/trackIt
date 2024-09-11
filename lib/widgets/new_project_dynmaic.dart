import 'dart:convert';
import 'package:expense_tracker/fireStore_Services/form_service.dart';
import 'package:expense_tracker/fireStore_Services/formdata_provider.dart';
import 'package:expense_tracker/utils/build_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewDynamicForm extends StatefulWidget {
  const NewDynamicForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewDynamicFormState createState() => _NewDynamicFormState();
}

class _NewDynamicFormState extends State<NewDynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};

  List<dynamic> _formFields = [];

  bool _isLoading = true;

  String? selectedCategory;
  List<String> subcategoryOptions = [];

  @override
  void initState() {
    super.initState();
    // _loadFormData();

    _loadFormFields();
    _loadFormDataFromRealtimeDatabase();
  }

  Future<void> _loadFormFields() async {
    final jsonString =
        await rootBundle.loadString('formsData/expense_form.json');
    final List<dynamic> formData = json.decode(jsonString);
    print(formData);

    // setState(() {
    //   _formFields = formData;
    // });
  }

  Future<void> _loadFormDataFromRealtimeDatabase() async {
    FormService formService = FormService();
    List<dynamic> formData = await formService.fetchFormData();
    setState(() {
      _formFields = formData;
    });
  }

  Future<void> _loadFormData() async {
    FormDataProvider formDataProvider = FormDataProvider();
    List<Map<String, dynamic>> formData =
        await formDataProvider.fetchFormData();

    setState(() {
      _formFields = formData;
      _isLoading = false; // Data is loaded
    });
  }

  void _handleValueChanged(String id, dynamic value) {
    setState(() {
      _formValues[id] = value;
    });
  }

  void _handleCategoryChanged(String id, String? value) {
    setState(() {
      selectedCategory = value;
      _formValues[id] = value;
      // Find the selected category's subcategories
      final categoryField =
          _formFields.firstWhere((field) => field['id'] == 'category');
      final selectedOption =
          categoryField['options'].firstWhere((opt) => opt['name'] == value);
      subcategoryOptions = List<String>.from(selectedOption['subcategories']);

      // Reset subcategory field
      _formValues['subcategory'] = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Process form data
      print(_formValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ..._formFields.map((field) {
              if (field['id'] == 'category') {
                return buildCategoryDropdown(field);
              } else if (field['id'] == 'subcategory') {
                return buildSubcategoryDropdown(field);
              } else {
                return buildFormField(
                  context,
                  field,
                  _formValues,
                  _handleValueChanged,
                );
              }
            }).toList(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryDropdown(Map<String, dynamic> field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: field['label'],
        ),
        value: selectedCategory,
        items: field['options'].map<DropdownMenuItem<String>>((dynamic option) {
          return DropdownMenuItem<String>(
            value: option['name'],
            child: Text(option['name']),
          );
        }).toList(),
        onChanged: (value) {
          _handleCategoryChanged(field['id'], value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a category';
          }
          return null;
        },
      ),
    );
  }

  Widget buildSubcategoryDropdown(Map<String, dynamic> field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: field['label'],
        ),
        value: _formValues['subcategory'],
        items: subcategoryOptions
            .map<DropdownMenuItem<String>>((String subcategory) {
          return DropdownMenuItem<String>(
            value: subcategory,
            child: Text(subcategory),
          );
        }).toList(),
        onChanged: (value) {
          _handleValueChanged(field['id'], value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a subcategory';
          }
          return null;
        },
      ),
    );
  }
}
