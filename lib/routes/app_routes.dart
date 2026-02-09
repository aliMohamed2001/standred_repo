import 'package:flutter/material.dart';
import 'package:new_standred/features/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
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

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (_) => const SplashScreen(),
    };
  }
}
