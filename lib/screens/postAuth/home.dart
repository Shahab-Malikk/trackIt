import 'package:expense_tracker/fireStore_Services/projects_service.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/widgets/home/balance_cards.dart';
import 'package:expense_tracker/widgets/home/recent_projects.dart';
import 'package:expense_tracker/widgets/home/wlecome_banner.dart';
import 'package:flutter/material.dart';

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
  List<Project> _recentProjects = [];
  @override
  void initState() {
    super.initState();
    _fetchAndStoreRecentProjects();
  }

  void _fetchAndStoreRecentProjects() async {
    List<Project> recentProjectsFromDb =
        await ProjectsService(fireStoreService).fetchRecentProjects(widget.uid);
    setState(() {
      _recentProjects = recentProjectsFromDb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const BalanceCards(),
            const SizedBox(height: 40),
            const Text(
              "Recent Projets",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            RecentProjects(
              recentProjects: _recentProjects,
              userId: widget.uid,
            )
          ],
        ),
      ),
    );
  }
}
