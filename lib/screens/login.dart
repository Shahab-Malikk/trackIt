import 'dart:convert';

import 'package:expense_tracker/fireStore_Services/auth_service.dart';
import 'package:expense_tracker/screens/signup.dart';
import 'package:expense_tracker/screens/tabs.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/utils/build_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    final List<dynamic> formData = allForms['login'];

    setState(() {
      _formFields = formData;
    });
  }

  void _handleValueChanged(String id, dynamic value) {
    setState(() {
      _formValues[id] = value;
    });
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final message = await AuthService().login(
        email: _formValues['email'],
        password: _formValues['password'],
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
        title: const Text('Login'),
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
                    context, field, _formValues, _handleValueChanged);
              }).toList(),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: TColors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: TSizes.fontSizeLg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
