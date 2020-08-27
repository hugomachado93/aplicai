import 'package:flutter/material.dart';
import 'package:aplicai/HomePage.dart';
import 'package:aplicai/signup_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage());
    }
  }
}
