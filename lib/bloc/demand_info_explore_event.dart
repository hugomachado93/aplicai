part of 'demand_info_explore_bloc.dart';

abstract class DemandInfoExploreEvent extends Equatable {
  const DemandInfoExploreEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUserAndEmployerData extends DemandInfoExploreEvent {
  String employerId;

  GetCurrentUserAndEmployerData({this.employerId});

  @override
  List<Object> get props => [employerId];
}

class GoToEmployerPerfil extends DemandInfoExploreEvent {
  Empreendedor empreendedor;

  GoToEmployerPerfil({this.empreendedor});

  @override
  List<Object> get props => [empreendedor];
}
