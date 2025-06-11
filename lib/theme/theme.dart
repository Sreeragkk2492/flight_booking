import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color darkBlue = Color(0xFF003366);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF1A1A1A);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryYellow,
      elevation: 0,
      iconTheme: IconThemeData(color: darkBlue),
      titleTextStyle: TextStyle(
        color: darkBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryYellow,
        foregroundColor: darkBlue,
        elevation: 8,
        shadowColor: primaryYellow.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryYellow),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryYellow, width: 2),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: primaryYellow,
      secondary: darkBlue,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBlue,
      elevation: 0,
      iconTheme: IconThemeData(color: primaryYellow),
      titleTextStyle: TextStyle(
        color: primaryYellow,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryYellow,
        foregroundColor: darkBlue,
        elevation: 8,
        shadowColor: primaryYellow.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryYellow),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryYellow, width: 2),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryYellow,
      secondary: darkBlue,
    ),
  );
}