import 'package:flutter/material.dart';
import '../presentation/home/view/home_page.dart';
import '../presentation/login/view/login_page.dart';
import '../presentation/splash/view/splash_page.dart';
import '../presentation/history/view/history_page.dart';
import '../presentation/stock/view/stock_page.dart';
import '../presentation/collection/view/collection_page.dart';
import '../presentation/profile/view/profile_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String history = '/history';
  static const String stock = '/stock';
  static const String collection = '/collection';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      case stock:
        return MaterialPageRoute(builder: (_) => const StockPage());
      case collection:
        return MaterialPageRoute(builder: (_) => const CollectionPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}