import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

class TBottomNavigationBarTheme {
  TBottomNavigationBarTheme._(); // To avoid creating instances

  static const lightBottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: Color(0xffeaeaea),
    selectedItemColor: TColors.secondary,
    unselectedItemColor: TColors.darkGrey,
    elevation: 0,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
    type: BottomNavigationBarType.fixed,
  );

  static const darkBottomNavBarTheme = BottomNavigationBarThemeData(
    backgroundColor: TColors.black,
    selectedItemColor: TColors.primary,
    unselectedItemColor: TColors.darkGrey,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
  );
}
