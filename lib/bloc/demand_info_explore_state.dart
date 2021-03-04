part of 'demand_info_explore_bloc.dart';

abstract class DemandInfoExploreState extends Equatable {
  const DemandInfoExploreState();

  @override
  List<Object> get props => [];
}

class DemandInfoExploreInitial extends DemandInfoExploreState {}

class DemandInfoExploreLoading extends DemandInfoExploreState {}

class DemandInfoExploreError extends DemandInfoExploreState {}

class DemandInfoExploreEmployerPerfil extends DemandInfoExploreState {
  Empreendedor empreendedor;

  DemandInfoExploreEmployerPerfil({this.empreendedor});

  @override
  List<Object> get props => [empreendedor];
}

class DemandInfoExploreGetUserAndEmployerData extends DemandInfoExploreState {
  String currentUserType;
  Empreendedor empreendedor;

  DemandInfoExploreGetUserAndEmployerData(
      {this.currentUserType, this.empreendedor});

  @override
  List<Object> get props => [currentUserType, empreendedor];
}
