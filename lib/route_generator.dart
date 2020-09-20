import 'package:aplicai/home_page.dart';
import 'package:aplicai/pages/navigation_page.dart';
import 'package:aplicai/pages/nova_demanda_page.dart';
import 'package:aplicai/pages/pre_singup_pages.dart';
import 'package:flutter/material.dart';
import 'package:aplicai/signup_start.dart';
import 'package:aplicai/pages/signup_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SignupStart());
      case '/signup-start':
        return MaterialPageRoute(builder: (_) => SignupStart());
      case '/signup-student':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case '/pre-signup-pages':
        return MaterialPageRoute(builder: (_) => PreSignupPages(userTypeEnum: args,));
      case '/nova-demanda':
        return MaterialPageRoute(builder: (_) => NovaDemandaPage());
      case '/navigation':
        return MaterialPageRoute(builder: (_) => NavigationPage());
    }
  }
}
