import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/widgets/categories_list.dart';
import 'package:expense_tracker/widgets/new_category.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<ExpenseCategory> categories = [
    ExpenseCategory(name: 'Abc', id: 'skjd')
  ];
  void _openAddCategoryOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewCategory(
        onAddCategory: _addCategory,
      ),
    );
  }

  void _addCategory(ExpenseCategory category) {
    setState(() {
      categories.add(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        'No categories added yet',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (categories.isNotEmpty) {
      mainContent = CategoriesList(categories: categories);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Categories/Sub-Categories'),
        actions: [
          IconButton(
            onPressed: _openAddCategoryOverlay,
            icon: const Icon(
              Icons.add_circle_outline,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        children: [Expanded(child: mainContent)],
      ),
    );
  }
}
