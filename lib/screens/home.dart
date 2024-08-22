import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/screens/categories.dart';
import 'package:expense_tracker/screens/expenses.dart';
import 'package:expense_tracker/screens/reconcilation.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/user_data_service.dart';
import 'package:expense_tracker/widgets/main_drawer.dart';
import 'package:expense_tracker/widgets/projects_list.dart';
import 'package:expense_tracker/widgets/wlecome_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.userName = '',
    this.uid = '',
    this.registeredExpenses = const [],
  });
  final String userName;
  final String uid;
  final List<Expense> registeredExpenses;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userData;
  String userName = '';
  String uid = '';
  // ignore: unused_field
  List<Expense> _registeredExpenses = [];
  List<Project> _recentProjects = [];
  @override
  void initState() {
    super.initState();
    // fetchCurrentUser(); // Fetch and store expenses when the widget is loaded
    // _fetchAndStoreExpenses();
    _fetchAndStoreRecentProjects();
  }

  void _fetchAndStoreExpenses() async {
    final List<Expense> expenses =
        await UserDataService(fireStoreService).fetchExpenses(uid);
    setState(() {
      _registeredExpenses = expenses;
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final financialData = Provider.of<FinancialData>(context, listen: false);
    //   final totalExpenses =
    //       _registeredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
    //   financialData.updateTotalExpenses(totalExpenses);
    // });
  }

  void _fetchAndStoreRecentProjects() async {
    List<Project> recentProjectsFromDb =
        await UserDataService(fireStoreService).fetchRecentProjects(widget.uid);
    setState(() {
      _recentProjects = recentProjectsFromDb;
    });
  }

  Future<void> fetchCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null) {
      uid = user.uid;
      try {
        userData = await UserDataService(fireStoreService).getUserData(uid);
        if (userData != null) {
          print('User Data: $userData');
          setState(() {
            userName = userData?['userName'];
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final financialData =
                Provider.of<FinancialData>(context, listen: false);

            // financialData.updateTotalIncome(userData?['balance']);
            financialData.updateTotalExpenses(userData?['expenses']);
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

  void _navigateToExpenses() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => ExpensesScreen(
              userId: widget.uid,
              registeredExpenses: widget.registeredExpenses,
            )));
  }

  void _navigateToCategories() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => const CategoriesScreen(),
    ));
  }

  void _navigateToReconcilation() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => const ReconcilationScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final financialData = Provider.of<FinancialData>(context);
    return Scaffold(
      drawer: MainDrawer(
        onNavigateToExpense: _navigateToExpenses,
        onNavigateToReconcilation: _navigateToReconcilation,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WlecomeBanner(
              userName: widget.userName,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: TColors.white,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up_sharp,
                            size: TSizes.iconLg,
                            color: TColors.lightGreen,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\$${financialData.totalBalance.toStringAsFixed(1)}',
                                style: const TextStyle(
                                    color: TColors.lightGreen,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900),
                              ),
                              const Text(
                                'Balance',
                                style: TextStyle(
                                    color: TColors.dark,
                                    fontSize: TSizes.fontSizeLg),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: TColors.white,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_down_sharp,
                            size: TSizes.iconLg,
                            color: TColors.lightOrange,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\$${financialData.totalExpenses.toStringAsFixed(1)}',
                                style: const TextStyle(
                                    color: TColors.lightOrange,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900),
                              ),
                              const Text(
                                'Expenses',
                                style: TextStyle(
                                    color: TColors.dark,
                                    fontSize: TSizes.fontSizeLg),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ), // Spacing between the cards
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Recent Projets",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Here are your recent projects , see all projects by navigating to Projects.",
              style: TextStyle(fontSize: 16, color: Colors.black38),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ProjectsList(
                projects: _recentProjects,
                userId: widget.uid,
              ),
            )
          ],
        ),
      ),
    );
  }
}
