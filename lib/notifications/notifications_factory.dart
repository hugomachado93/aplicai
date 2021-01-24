import 'package:aplicai/entity/notify.dart';
import 'package:aplicai/notifications/notification_enum.dart';
import 'package:flutter/material.dart';

abstract class NotificationsFactory {
  Widget createCard(Notify notify);
  String getType();
}
