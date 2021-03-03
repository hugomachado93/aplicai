part of 'demand_info_bloc.dart';

abstract class DemandInfoEvent extends Equatable {
  const DemandInfoEvent();

  @override
  List<Object> get props => [];
}

class GetAllUsers extends DemandInfoEvent {
  String employerId;
  String studentUserListId;

  GetAllUsers({this.employerId, this.studentUserListId});

  @override
  List<Object> get props => [employerId, studentUserListId];
}
