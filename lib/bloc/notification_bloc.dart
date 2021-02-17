import 'dart:async';

import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial());
  UserService userService = UserService();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if(event is GetNotifications) {
      yield NotificationLoading();
      final snapshot = await userService.getUserNotifications(event.userEntity);
      yield NotificationLoaded(notifySnapshot: snapshot.docs);
    }
  }
}
