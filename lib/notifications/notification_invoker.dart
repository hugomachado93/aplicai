import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/notifications/demand_first_recommend_notification.dart';
import 'package:aplicai/notifications/demand_recommend_notification.dart';
import 'package:aplicai/notifications/notifications_strategy.dart';
import 'package:aplicai/notifications/request_notification.dart';
import 'package:aplicai/notifications/signup_notification.dart';
import 'package:aplicai/notifications/subscription_notification.dart';
import 'package:flutter/material.dart';

class NotificationInvoker {
  List<NotificationsStrategy> notifications = [
    SignupNotification(),
    SubscriptionNotification(),
    RequestNotification(),
    DemandRecommendNotification(),
    DemandFirstRecomemndNotification(),
  ];

  Widget invokeNotificationByType(Notify notify) {
    return notifications
        .firstWhere((e) => e.getType() == notify.type)
        .createCard(notify);
  }
}
