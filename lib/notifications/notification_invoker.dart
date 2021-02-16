import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/notifications/notifications_factory.dart';
import 'package:aplicai/notifications/signup_notification.dart';
import 'package:aplicai/notifications/subscription_notification.dart';
import 'package:flutter/material.dart';

class NotificationInvoker {
  List<NotificationsFactory> notifications = [
    SignupNotification(),
    SubscriptionNotification()
  ];

  Widget invokeNotificationByType(Notify notify) {
    for(var notification in notifications) {
      if(notification.getType() == notify.type) {
        return notification.createCard(notify);
      }
    }
  }
}