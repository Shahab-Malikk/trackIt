import 'package:expense_tracker/auth_service.dart';
import 'package:expense_tracker/screens/signup.dart';
import 'package:expense_tracker/screens/tabs.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final message = await AuthService().login(
                    email: _emailController.text,
                    password: _passwordController.text,
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
                },
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
    );
  }
}
