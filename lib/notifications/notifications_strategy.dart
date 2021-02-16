import 'package:aplicai/entity/notify.dart';
import 'package:flutter/material.dart';

abstract class NotificationsStrategy {
  Widget createCard(Notify notify);
  String getType();
}
