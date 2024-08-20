import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key, required this.categories});
  final List<ExpenseCategory> categories;

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.categories.length,
      itemBuilder: (context, index) => Dismissible(
          key: ValueKey(index),
          background: Container(),
          child: Row(
            children: [
              Text(widget.categories[index].name),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle))
            ],
          )),
    );
  }
}
