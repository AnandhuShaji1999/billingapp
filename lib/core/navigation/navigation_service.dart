import 'package:flutter/material.dart';

/// Global navigator key so non-widget code (like ApiClient, when a token
/// refresh fails) can navigate the app back to the login screen without
/// needing a BuildContext.
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}