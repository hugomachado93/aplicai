import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/notifications/notification_enum.dart';
import 'package:aplicai/notifications/notifications_strategy.dart';
import 'package:flutter/material.dart';

class SignupNotification implements NotificationsStrategy {
  @override
  Widget createCard(Notify notify) {
    return Container(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(15),
        child: Row(children: [
          Text("Ola ${notify.name}, ", style: TextStyle(fontSize: 20)),
          Expanded(
            child: Text(
              notify.notification,
              style: TextStyle(fontSize: 18),
            ),
          )
        ]),
      ),
    );
  }

  @override
  String getType() {
    return NotificationType.Signup.toString().split('.').last.toLowerCase();
  }
}
