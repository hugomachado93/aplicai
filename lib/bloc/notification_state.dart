part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => throw UnimplementedError();
}

class NotificationInitial extends NotificationState {
}

class NotificationLoading extends NotificationState {
}

class NotificationLoaded extends NotificationState {

  final List<QueryDocumentSnapshot> notifySnapshot;

  NotificationLoaded({this.notifySnapshot});

  @override
  List<Object> get props => [notifySnapshot];
}