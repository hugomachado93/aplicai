part of 'demand_info_bloc.dart';

abstract class DemandInfoState extends Equatable {
  const DemandInfoState();

  @override
  List<Object> get props => [];
}

class DemandInfoInitial extends DemandInfoState {}

class DemandInfoLoading extends DemandInfoState {}

class DemandInfoAllUsers extends DemandInfoState {
  Empreendedor empreendedor;
  List<UserEntity> students;
  String currentUserType;

  DemandInfoAllUsers({this.empreendedor, this.students, this.currentUserType});

  @override
  // TODO: implement props
  List<Object> get props => [empreendedor, students, currentUserType];
}
