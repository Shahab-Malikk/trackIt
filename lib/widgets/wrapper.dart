import 'package:expense_tracker/screens/login.dart';
import 'package:expense_tracker/screens/onboarding.dart';
import 'package:expense_tracker/screens/tabs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      return Tabs();
    } else {
      return OnboardingScreen();
    }
  }
}
