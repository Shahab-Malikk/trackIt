import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/screens/onboarding.dart';
import 'package:expense_tracker/screens/splash.dart';
import 'package:expense_tracker/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black, // Black background for status bar
      statusBarIconBrightness: Brightness.light, // Light icons
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => FinancialData(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MaterialApp(
      theme: TAppTheme.lightTheme,
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.black, // Black background for status bar
            statusBarIconBrightness: Brightness.light, // Light icons
          ),
        );
        return child!;
      },
      home: const SplashScreen(),
    );
  }
}
