import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/screens/auth/login.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  const ProfileScreen({super.key, required this.userName});

  get firstLetterofName => userName[0].toUpperCase();
  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<FinancialData>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                child: ClipOval(
                  child: Container(
                    color: TColors.darkGrey,
                    child: Center(
                      child: Text(
                        firstLetterofName,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                userName,
                style: const TextStyle(
                    color: TColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then((res) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false);
              });
              balanceProvider.resetAmounts();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.logout_outlined), Text('Logout')],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
