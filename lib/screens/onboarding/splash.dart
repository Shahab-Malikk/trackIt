import 'package:expense_tracker/screens/onboarding/onboarding.dart';
import 'package:expense_tracker/widgets/utils/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 5), () {
      _isOnboardingCompleted();
    });
  }

  Future<void> _isOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted = prefs.getBool('isOnboardingCompleted');
    Widget toBeNavigated;
    (isOnboardingCompleted != null && isOnboardingCompleted)
        ? toBeNavigated = const Wrapper()
        : toBeNavigated = const OnboardingScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => toBeNavigated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/trackitLogo.png',
              width: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Track It, Save It, Own It",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
