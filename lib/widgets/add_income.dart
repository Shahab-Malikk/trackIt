import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _incomeController = TextEditingController();

  void _addBalance() {
    final enteredAmount = double.tryParse(_incomeController.text);
    if (enteredAmount == 0 || enteredAmount == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text('Please  enter valid amount.'),
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
      double previousBalance = financialData.leftBalance;
      print(previousBalance);
      financialData.updateTotalIncome(enteredAmount);
      print(previousBalance);
      double currentBalance = previousBalance + enteredAmount;
      financialData.updateTotalIncome(currentBalance);
      print(currentBalance);
      FirebaseFirestore.instance
          .collection('users')
          .doc('SSQPg3UmfvhN4HcEEX5PybgTHG62')
          .update({
        'balance': currentBalance,
      });
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150.w,
          child: TextField(
            controller: _incomeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '\$',
              label: Text('Income'),
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(),
            ),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: const Text('Cancel',
              //         style: TextStyle(
              //           fontSize: TSizes.fontSizeLg,
              //           color: TColors.black,
              //         ))),
              SizedBox(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  onPressed: _addBalance,
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
