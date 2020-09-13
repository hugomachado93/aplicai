import 'package:aplicai/home_page.dart';
import 'package:aplicai/pages/navigation_page.dart';
import 'package:aplicai/pages/pre_singup_pages.dart';
import 'package:flutter/material.dart';
import 'package:aplicai/signup_start.dart';
import 'package:aplicai/pages/signup_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => NavigationPage());
      case '/signup-start':
        return MaterialPageRoute(builder: (_) => SignupStart());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case '/pre-signup-pages':
        return MaterialPageRoute(builder: (_) => PreSignupPages());
    }
  }
}
