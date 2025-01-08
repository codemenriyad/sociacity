import 'package:flutter/material.dart';
import 'package:sociacity/auth/view/login_screen.dart';
import 'package:sociacity/auth/view/signup_screen.dart';
import 'package:sociacity/bottomnavigation/view/bottom_navigation.dart';
import 'package:sociacity/home/view/post_detail.dart';

class Routes {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginPage.route:
        return _buildRoute(
          const LoginPage(),
          settings,
        );
      case PostDetailPage.route:
        final args = settings.arguments! as Map<String, dynamic>;
        return _buildRoute(
          PostDetailPage(
            post: args,
          ),
          settings,
        );
      case SignupPage.route:
        return _buildRoute(
          const SignupPage(),
          settings,
        );
      case BottomNavigationScreen.route:
        return _buildRoute(
          const BottomNavigationScreen(),
          settings,
        );

      default:
        return null;
    }
  }

  // ignore: strict_raw_type
  static MaterialPageRoute _buildRoute(Widget child, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => child,
      settings: settings,
    );
  }
}
