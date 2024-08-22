import 'package:expense_tracker/models/financial_data.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/widgets/add_income.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ReconcilationScreen extends StatefulWidget {
  const ReconcilationScreen({super.key});

  @override
  State<ReconcilationScreen> createState() => _ReconcilationScreenState();
}

class _ReconcilationScreenState extends State<ReconcilationScreen> {
  void _openAddIncomeOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const AddIncome(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final financialData = Provider.of<FinancialData>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                          vertical: 50, horizontal: 15),
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
                                    fontWeight: FontWeight.w900),
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
                      Icon(Icons.add_circle, size: 30.w, color: TColors.white),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Add Balance',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            color: TColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
