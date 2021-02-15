import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/notifications/notification_enum.dart';
import 'package:aplicai/notifications/notifications_factory.dart';
import 'package:flutter/material.dart';

class SignupNotification implements NotificationsFactory {
  @override
  Widget createCard(Notify notify) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(15),
        child: Container(
            height: 200,
            child: Row(children: [
              Container(
                  height: 120,
                  width: 80,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(notify.imageUrl)))),
              Text(notify.name),
              Text(notify.notification, style: TextStyle(
                fontSize: 20
              ),)
            ])));
  }

  @override
  String getType() {
    return NotificationType.Signup.toString().split('.').last.toLowerCase();
  }

}
