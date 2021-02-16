import 'package:aplicai/home_page.dart';
import 'package:aplicai/pages/demand_info_explore_page.dart';
import 'package:aplicai/pages/demand_info_page.dart';
import 'package:aplicai/pages/demand_subscription.dart';
import 'package:aplicai/pages/navigation_page.dart';
import 'package:aplicai/pages/notification_page.dart';
import 'package:aplicai/pages/nova_demanda_page.dart';
import 'package:aplicai/pages/pre_singup_pages.dart';
import 'package:aplicai/pages/signup_page_empreendedor.dart';
import 'package:aplicai/pages/solicitation_detail.dart';
import 'package:aplicai/pages/solicitation_page.dart';
import 'package:aplicai/pages/subscription_finished.dart';
import 'package:flutter/material.dart';
import 'package:aplicai/signup_start.dart';
import 'package:aplicai/pages/signup_page.dart';

import 'root.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => RootPage());
      case '/signup-start':
        return MaterialPageRoute(builder: (_) => SignupStart());
      case '/signup-student':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case '/signup-employer':
        return MaterialPageRoute(builder: (_) => SignupPageEmpreendedor());
      case '/pre-signup-pages':
        return MaterialPageRoute(
            builder: (_) => PreSignupPages(
                  userTypeEnum: args,
                ));
      case '/nova-demanda':
        return MaterialPageRoute(builder: (_) => NovaDemandaPage());
      case '/navigation':
        return MaterialPageRoute(builder: (_) => NavigationPage());
      case '/demand-info':
        return MaterialPageRoute(builder: (_) => DemandInfoPage(demanda: args));
      case '/demand-info-explore':
        return MaterialPageRoute(
            builder: (_) => DemandInfoExplorePage(demanda: args));
      case '/demand-subscription':
        return MaterialPageRoute(
            builder: (_) => DemandSubscriptionPage(demanda: args));
      case '/finished-subscription':
        return MaterialPageRoute(
            builder: (_) => SubscriptionFinishedPage(demanda: args));
      case '/solicitation':
        return MaterialPageRoute(
            builder: (_) => SolicitationPage(demanda: args));
      case '/solicitation-detail':
        return MaterialPageRoute(
            builder: (_) => SolicitationDetailPage(
                  demanda: args,
                ));
      case '/notifications':
        return MaterialPageRoute(builder: (_) => NotificationPage());
    }
  }
}
