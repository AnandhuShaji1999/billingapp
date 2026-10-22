import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/navigation/navigation_service.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const ShopBillingApp());
}

class ShopBillingApp extends StatelessWidget {
  const ShopBillingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Billing',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.appBarBackground,
          foregroundColor: AppColors.appBarForeground,
          elevation: 0,
        ),
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}