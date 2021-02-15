import 'dart:async';
import 'package:aplicai/service/user_service.dart';

class BadgeBloc {
  int _total = 0;
  int get total => _total;

  final _blocController = StreamController<int>();

  Stream<int> get stream => _blocController.stream;

  void getNotificationNumBadge() async {
    UserService userService = new UserService();
    _blocController.sink.add(await userService.getUserNumNotifications());
  }

  closeStream() {
    _blocController.close();
  }

}