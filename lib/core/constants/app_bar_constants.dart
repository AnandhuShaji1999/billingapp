import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppBarConstants {
  AppBarConstants._();

  static const double height = kToolbarHeight;
  static const double elevation = 0;

  static const Color backgroundColor = AppColors.appBarBackground;
  static const Color foregroundColor = AppColors.appBarForeground;

  static const TextStyle titleStyle = TextStyle(
    color: AppColors.appBarForeground,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const IconThemeData iconTheme = IconThemeData(
    color: AppColors.appBarForeground,
  );
}