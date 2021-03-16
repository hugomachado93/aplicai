import 'package:aplicai/home_page.dart';
import 'package:aplicai/pages/demand_info_explore_page.dart';
import 'package:aplicai/pages/demand_info_page.dart';
import 'package:aplicai/pages/demand_subscription.dart';
import 'package:aplicai/pages/employer_demand_info.dart';
import 'package:aplicai/pages/navigation_page.dart';
import 'package:aplicai/pages/notification_page.dart';
import 'package:aplicai/pages/nova_demanda_page.dart';
import 'package:aplicai/pages/pre_singup_pages.dart';
import 'package:aplicai/pages/signup_page_empreendedor.dart';
import 'package:aplicai/pages/solicitation_detail.dart';
import 'package:aplicai/pages/solicitation_page.dart';
import 'package:aplicai/pages/employer_info.dart';
import 'package:aplicai/pages/student_demand_info.dart';
import 'package:aplicai/pages/subscription_finished.dart';
import 'package:aplicai/signup_with_email.dart';
import 'package:flutter/material.dart';
import 'package:aplicai/signup_start.dart';
import 'package:aplicai/pages/signup_page.dart';

import 'root.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => RootPage(), settings: settings);
      case '/signup-start':
        return MaterialPageRoute(builder: (_) => SignupStart(), settings: settings);
      case '/signup-student':
        return MaterialPageRoute(builder: (_) => SignupPage(), settings: settings);
      case '/signup-employer':
        return MaterialPageRoute(builder: (_) => SignupPageEmpreendedor(), settings: settings);
      case '/pre-signup-pages':
        return MaterialPageRoute(
            builder: (_) => PreSignupPages(
                  userTypeEnum: args,
                ), settings: settings);
      case '/nova-demanda':
        return MaterialPageRoute(builder: (_) => NovaDemandaPage(), settings: settings);
      case '/navigation':
        return MaterialPageRoute(builder: (_) => NavigationPage(), settings: settings);
      case '/demand-info':
        return MaterialPageRoute(builder: (_) => DemandInfoPage(demanda: args), settings: settings);
      case '/demand-info-explore':
        return MaterialPageRoute(
            builder: (_) => DemandInfoExplorePage(demanda: args), settings: settings);
      case '/demand-subscription':
        return MaterialPageRoute(
            builder: (_) => DemandSubscriptionPage(demanda: args), settings: settings);
      case '/finished-subscription':
        return MaterialPageRoute(
            builder: (_) => SubscriptionFinishedPage(demanda: args), settings: settings);
      case '/solicitation':
        return MaterialPageRoute(
            builder: (_) => SolicitationPage(demanda: args), settings: settings);
      case '/solicitation-detail':
        return MaterialPageRoute(
            builder: (_) => SolicitationDetailPage(
                  demanda: args,
                ), settings: settings);
      case '/notifications':
        return MaterialPageRoute(builder: (_) => NotificationPage(), settings: settings);
      case '/employer-info':
        return MaterialPageRoute(
            builder: (_) => EmployerInfo(
                  empreendedor: args,
                ), settings: settings);
      case '/employer-demand-info':
        return MaterialPageRoute(
            builder: (_) => EmployerDemandInfo(
                  demanda: args,
                ), settings: settings);
      case '/student-demand-info':
        return MaterialPageRoute(
            builder: (_) => StudentDemandInfo(
                  demanda: args,
                ), settings: settings);
      case '/signup-with-email':
        return MaterialPageRoute(builder: (_) => SignupWithEmail(), settings: settings);
    }
  }
}
