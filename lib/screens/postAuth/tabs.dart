import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/screens/postAuth/home.dart';
import 'package:expense_tracker/screens/postAuth/profile.dart';
import 'package:expense_tracker/screens/onboarding/projects.dart';
import 'package:expense_tracker/screens/postAuth/reconcilation.dart';
import 'package:expense_tracker/fireStore_Services/user_data_service.dart';
import 'package:expense_tracker/widgets/utils/load_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedPageIndex = 0;
  Map<String, dynamic>? userData;
  String userName = '';
  String uid = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  Future<void> fetchCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null) {
      uid = user.uid;
      try {
        userData = await UserDataService(fireStoreService).getUserData(uid);
        if (userData != null) {
          // debugPrint('User Data: $userData');
          setState(() {
            userName = userData?['userName'];
            _isLoading = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final financialData =
                Provider.of<FinancialData>(context, listen: false);
            double income = userData?['balance']?.toDouble() ?? 0.0;
            double expenses = userData?['expenses']?.toDouble() ?? 0.0;
            financialData.updateTotalIncome(income);
            financialData.updateTotalExpenses(expenses);
          });
        } else {
          print('No data found for user with UID: $uid');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = HomeScreen(
      uid: uid,
      userName: userName,
    );
    String activePageTitle = 'TrackIt';

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Projects';
      activePage = ProjectsScreen(
        userId: uid,
      );
    }
    if (_selectedPageIndex == 2) {
      activePageTitle = 'Reconcilation';
      activePage = ReconcilationScreen(
        userId: uid,
      );
    }
    if (_selectedPageIndex == 3) {
      activePageTitle = 'Profile';
      activePage = ProfileScreen(
        userName: userName,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: RefreshIndicator(
        onRefresh: fetchCurrentUser,
        child: _isLoading ? const LoadIndicator() : activePage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          _selectPage(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(
              icon: Icon(Icons.money), label: 'Reconcilation'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
