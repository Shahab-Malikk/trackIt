import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/fireStore_Services/form_service.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/utils/build_form.dart';
import 'package:expense_tracker/widgets/utils/load_indicator.dart';
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
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {};
  List<dynamic> _formFields = [];
  // List<String> contributors = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _fetchContributors();
    _loadFormDataFromRealtimeDatabase();
  }

  Future<void> _loadFormDataFromRealtimeDatabase() async {
    FormService formService = FormService();
    List<dynamic> formData = await formService.fetchFormData();
    setState(() {
      _formFields = formData;
      _isLoading = false;
    });
  }

//Method to add balance to the user's account
  void _addBalance() {
    if (_formKey.currentState?.validate() ?? false) {
      final enteredAmount = double.tryParse(_formValues['income']);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final financialData =
            Provider.of<FinancialData>(context, listen: false);
        double previousBalance = financialData.totalBalance;
        financialData.updateTotalIncome(enteredAmount!);
        double currentBalance = previousBalance + enteredAmount;
        financialData.updateTotalIncome(currentBalance);
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'balance': currentBalance,
        });
      });

      final income = Income(
        id: uuid.v4(),
        date: DateTime.parse(_formValues['date']!),
        description: _formValues['description'],
        paidBy: _formValues['paidBy'],
        amount: enteredAmount!,
      );

      widget.onAddIncome(income);

      Navigator.pop(context);
    }
  }

  void _handleValueChanged(String id, dynamic value) {
    setState(() {
      _formValues[id] = value;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadIndicator()
        : Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ..._formFields.map((field) {
                    return buildFormField(
                        context, field, _formValues, _handleValueChanged);
                  }),
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        onPressed: _addBalance,
                        child: const Text('Save Data'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
