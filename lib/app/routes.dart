import 'package:flutter/material.dart';
import 'package:smartbox/ui/country/choose_country_screen.dart';

import '../ui/auth/login_screen.dart';
import '../ui/auth/registration_screen.dart';
import '../ui/main/main_screen.dart';
import '../ui/main/splash_screen.dart';

class Routes {
  static const home = "/";
  static const login = "login";
  static const register = "register";
  static const splash = 'splash';
  static const country_choice = 'country_choose';
  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case register:
        return MaterialPageRoute(
            builder: (context) => const RegistrationScreen());
        case country_choice:
        return MaterialPageRoute(
            builder: (context) => const ChooseCountryScreen());
      default:
        return MaterialPageRoute(builder: (context) => const Scaffold());
    }
  }
}
