import 'package:aplicai/entity/notify.dart';
import 'package:flutter/material.dart';

abstract class NotificationsFactory {
  Widget createCard(Notify notify);
}
