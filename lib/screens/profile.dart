import 'package:expense_tracker/screens/login.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                radius: 70,
                child: ClipOval(
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: const NetworkImage(
                        'https://media.licdn.com/dms/image/D4D03AQEn8m5hZ1nfwA/profile-displayphoto-shrink_800_800/0/1723755435752?e=1729123200&v=beta&t=af4Qf3JxhoNyh7AdSNy_Bm3D0sk5zvDl5nG9UIOHfDU'),
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
              const Text(
                "Shahab Malik",
                style: TextStyle(
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
