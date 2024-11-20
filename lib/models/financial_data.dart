import 'package:flutter/material.dart';

class FinancialData extends ChangeNotifier {
  double _totalBalance = 0.00;
  double _totalExpenses = 0.00;

  double get totalExpenses => _totalExpenses;
  double get totalBalance => _totalBalance;

  void updateTotalExpenses(double newTotal) {
    _totalExpenses = newTotal;
    notifyListeners();
  }

  void updateTotalIncome(double newIncome) {
    _totalBalance = newIncome;
    notifyListeners();
  }

  void resetAmounts() {
    _totalBalance = 0.00;
    _totalExpenses = 0.00;
    notifyListeners();
  }
}

class FinancialDataService {}
