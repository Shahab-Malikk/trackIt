import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({super.key, required this.onAddCategory});
  final void Function(ExpenseCategory category) onAddCategory;

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final _categoryName = TextEditingController();
  final uuid = Uuid();

  void _submitExpenseData() {
    if (_categoryName.text.trim().isEmpty) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text('Please  enter a category name.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('Ok'),
                )
              ],
            );
          });

      return;
    }
    widget.onAddCategory(
        ExpenseCategory(name: _categoryName.text, id: uuid.v4()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _categoryName,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Category Name'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Category')),
            ],
          )
        ],
      ),
    );
  }
}
