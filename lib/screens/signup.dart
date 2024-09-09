import 'dart:convert';
import 'package:expense_tracker/fireStore_Services/auth_service.dart';
import 'package:expense_tracker/screens/tabs.dart';
import 'package:expense_tracker/utils/build_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  List<dynamic> _formFields = [];

  @override
  void initState() {
    super.initState();
    _loadFormFields();
  }

  Future<void> _loadFormFields() async {
    final jsonString = await rootBundle.loadString('formsData/auth_form.json');
    final Map<String, dynamic> allForms = json.decode(jsonString);
    final List<dynamic> formData = allForms['signup'];

    setState(() {
      _formFields = formData;
    });
  }

  void _handleValueChanged(String id, dynamic value) {
    setState(() {
      _formValues[id] = value;
    });
  }

  void _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      print(_formValues);
      final message = await AuthService().registration(
        email: _formValues['email'],
        password: _formValues['password'],
        userName: _formValues['name'],
      );
      if (message!.contains('Success')) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Tabs(),
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/trackitLogo.png',
                width: 200,
              ),
              const SizedBox(
                height: 50,
              ),
              ..._formFields.map((field) {
                return buildFormField(
                  context,
                  field,
                  _formValues,
                  _handleValueChanged,
                );
              }).toList(),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signup,
                  child: const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
