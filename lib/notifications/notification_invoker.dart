import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/notifications/notifications_factory.dart';
import 'package:aplicai/notifications/signup_notification.dart';
import 'package:flutter/material.dart';

class NotificationInvoker {
  List<NotificationsFactory> notifications = [
    SignupNotification()
  ];

  Widget invokeNotificationByType(Notify notify) {
    for(var notification in notifications) {
      if(notification.getType() == notify.name) {
        return notification.createCard(notify);
      }
    }
  }

}