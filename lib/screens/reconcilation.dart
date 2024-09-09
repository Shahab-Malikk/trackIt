import 'package:expense_tracker/fireStore_Services/income_srvice.dart';
import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/widgets/add_income.dart';
import 'package:expense_tracker/widgets/income_records.dart';
import 'package:expense_tracker/widgets/new_project_dynmaic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ReconcilationScreen extends StatefulWidget {
  final String userId;
  const ReconcilationScreen({super.key, required this.userId});

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

    await IncomeSrvice(fireStoreService).storeIncomeInDb(income, widget.userId);
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
      builder: (ctx) => NewDynamicForm(),

      // AddIncome(
      //   onAddIncome: _addIncome,
      //   userId: widget.userId,
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final financialData = Provider.of<FinancialData>(context);
    return Scaffold(
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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, Malik",
                                style: TextStyle(
                                  fontSize: TSizes.fontSizeLg,
                                  fontWeight: FontWeight.w600,
                                  color: TColors.black,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
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
                                '\$ ${financialData.totalBalance.toString()}',
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
            Center(
              child: SizedBox(
                width: 300,
                height: 60,
                child: ElevatedButton(
                  onPressed: _openAddIncomeOverlay,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle,
                        size: 30.w,
                        color: TColors.white,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Add Balance',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              color: TColors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
