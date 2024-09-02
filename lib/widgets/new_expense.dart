import 'package:expense_tracker/fireStore_Services/category_service.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;
  final String userId;
  final String projectId;
  const NewExpense({
    super.key,
    required this.onAddExpense,
    required this.userId,
    this.projectId = "",
  });

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  List<String> contributors = [];
  List<ExpenseCategory> categories = [];
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> subCategories = [];

  DateTime? _selectedDate;
  String? _selectedCategory; // Initialize with an empty string for now
  String? _selectedCategoryId;
  String? _slectedSubCategory;
  String? _paidBy;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchContributors();
  }

  void _fetchContributors() async {
    final List<String> contributorsFromDb =
        await CategoryService(fireStoreService).getRecievers();
    setState(() {
      contributors = contributorsFromDb;
    });
  }

  void _fetchCategories() async {
    final List<ExpenseCategory> categoriesFromDb =
        await CategoryService(fireStoreService).fetchCategories();
    setState(() {
      categories = categoriesFromDb;
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _onCategoryChanged(String? selectedCategoryId) async {
    if (selectedCategoryId == null) return;

    final selectedCategory = categories.firstWhere(
      (category) => category.id == selectedCategoryId,
      orElse: () => categories[0], // Fallback if not found
    );

    List<String> subCategoriesFromDb = await CategoryService(fireStoreService)
        .getSubcategories(selectedCategoryId);

    setState(() {
      _selectedCategoryId = selectedCategory.id;
      _selectedCategory = selectedCategory.name;
      subCategories = subCategoriesFromDb;
    });
  }

  void _submitExpenseData() async {
    final enteredAmount = double.tryParse(_priceController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text('Please  enter valid data'),
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
    final expense = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory!,
      subCategory: _slectedSubCategory!,
      description: _descriptionController.text,
      paidBy: _paidBy!,
    );

    widget.onAddExpense(expense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    label: Text('Price'),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Selected'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton<String>(
                hint: const Text('Select Category'),
                value: _selectedCategoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _onCategoryChanged(value);
                  }
                },
              ),
              const Spacer(),
              if (subCategories.isNotEmpty) ...[
                DropdownButton<String>(
                  hint: const Text('Select Subcategory'),
                  value: _slectedSubCategory,
                  items: subCategories
                      .map((subCategory) => DropdownMenuItem(
                          value: subCategory, child: Text(subCategory)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _slectedSubCategory = value;
                    });
                  },
                ),
              ],
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DropdownButton<String>(
                hint: const Text('Paid To'),
                value: _paidBy,
                items: contributors.map((person) {
                  return DropdownMenuItem<String>(
                    value: person,
                    child: Text(person),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _paidBy = value;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
          TextField(
            controller: _descriptionController,
            maxLength: 250,
            decoration: const InputDecoration(
              label: Text('Description'),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: TSizes.fontSizeLg,
                    color: TColors.black,
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Expense'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
