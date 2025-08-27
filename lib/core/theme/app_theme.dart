import 'package:flutter/material.dart';
import 'package:storifuel/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: primaryColor,
      cardColor: primaryColor,
      dividerColor: primaryColor,
    );
  }
}