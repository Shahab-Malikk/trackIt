import 'package:expense_tracker/fireStore_Services/income_srvice.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/utils/utility_functions.dart';
import 'package:expense_tracker/widgets/reconcilation/add_income.dart';
import 'package:expense_tracker/widgets/reconcilation/income_records.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ReconcilationScreen extends StatefulWidget {
  final String userId;
  final String userName;
  const ReconcilationScreen(
      {super.key, required this.userId, required this.userName});

  @override
  State<ReconcilationScreen> createState() => _ReconcilationScreenState();
}

class _ReconcilationScreenState extends State<ReconcilationScreen> {
  List<Income> _incomeRecord = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchIncomeRecordFromDb();
  }

  void _addIncome(Income income) async {
    setState(() {
      _incomeRecord.add(income);
    });

    try {
      await IncomeSrvice(fireStoreService)
          .storeIncomeInDb(income, widget.userId);
      UtilityFunctions().showInfoMessage("Balance added successfuly", context);
    } catch (e) {
      UtilityFunctions().showInfoMessage("An error occured", context);
      print(e);
    }
  }

  void _fetchIncomeRecordFromDb() async {
    List<Income> incomeRecordFromDb =
        await IncomeSrvice(fireStoreService).fetchIncomeRecord(widget.userId);

    setState(() {
      _incomeRecord = incomeRecordFromDb;
    });
  }

  void _openAddIncomeOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddIncome(
        onAddIncome: _addIncome,
        userId: widget.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final financialData = Provider.of<FinancialData>(context);
    return Scaffold(
      floatingActionButton: Tooltip(
        message: "Add Income",
        decoration: BoxDecoration(
          color: Colors.black87, // Background color of the tooltip
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          color: Colors.white, // Text color
        ),
        waitDuration:
            const Duration(milliseconds: 500), // Time before tooltip appears
        showDuration:
            const Duration(seconds: 2), // How long the tooltip is shown
        child: FloatingActionButton(
          backgroundColor: TColors.black,
          onPressed: _openAddIncomeOverlay,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: TColors.white,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 15,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello, ${widget.userName}",
                                style: const TextStyle(
                                  fontSize: TSizes.fontSizeLg,
                                  fontWeight: FontWeight.w600,
                                  color: TColors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Your current balance is ...",
                                style: TextStyle(
                                  color: TColors.darkGrey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                financialData.totalBalance.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: TColors.lightGreen,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Balance Record",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: IncomeRecords(
                incomeRecords: _incomeRecord,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
