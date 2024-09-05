import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/fireStore_Services/category_service.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddIncome extends StatefulWidget {
  final void Function(Income income) onAddIncome;
  final String userId;
  const AddIncome({super.key, required this.onAddIncome, required this.userId});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  List<String> contributors = [];
  final _incomeController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _paidBy;

  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchContributors();
  }

  void _fetchContributors() async {
    final List<String> contributorsFromDb =
        await CategoryService(fireStoreService).getSenders();
    setState(() {
      contributors = contributorsFromDb;
    });
  }

  void _addBalance() {
    final enteredAmount = double.tryParse(_incomeController.text);
    if (enteredAmount == 0 || enteredAmount == null || _selectedDate == null) {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final financialData = Provider.of<FinancialData>(context, listen: false);
      double previousBalance = financialData.totalBalance;
      financialData.updateTotalIncome(enteredAmount);
      double currentBalance = previousBalance + enteredAmount;
      financialData.updateTotalIncome(currentBalance);
      FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'balance': currentBalance,
      });
    });

    final income = Income(
      id: uuid.v4(),
      date: _selectedDate!,
      description: _descriptionController.text,
      paidBy: _paidBy!,
      amount: enteredAmount,
    );

    widget.onAddIncome(income);

    Navigator.pop(context);
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

  @override
  void dispose() {
    // TODO: implement dispose
    _incomeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _incomeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text('Income'),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  hint: const Text('Paid By'),
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
                  child: const Text('Cancel',
                      style: TextStyle(
                        fontSize: TSizes.fontSizeLg,
                        color: TColors.black,
                      ))),
              SizedBox(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  onPressed: _addBalance,
                  child: const Text('Save Data'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
