import 'package:flutter/material.dart';

class FinancialData extends ChangeNotifier {
  double _totalBalance = 0.0;
  double _totalExpenses = 0.0;

  // double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  double get totalBalance => _totalBalance;
  double get leftBalance => _totalBalance;

  void updateTotalExpenses(double newTotal) {
    _totalExpenses = newTotal;
    notifyListeners();
  }

  void updateTotalIncome(double newIncome) {
    _totalBalance = newIncome;
    notifyListeners();
  }
}

class FinancialDataService {}
