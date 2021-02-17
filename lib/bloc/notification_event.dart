part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class GetNotifications extends NotificationEvent {
  final UserEntity userEntity;

  GetNotifications({this.userEntity});

  @override
  List<Object> get props => [this.userEntity];
}