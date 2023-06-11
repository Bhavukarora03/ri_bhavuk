import 'package:flutter/material.dart';

const Color primaryColor = Color(0xff1DA1F2);
const Color secondaryColor = Color(0xffEDF8FF);
const Color scaffoldBackgroundColor = Color(0xffF2F2F2);

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  useMaterial3: true,
  inputDecorationTheme: const InputDecorationTheme(
    suffixIconColor: primaryColor,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      borderSide: BorderSide(
        color: Color(0xffE5E5E5),
      ),
    ),
    prefixIconColor: primaryColor,
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
);
