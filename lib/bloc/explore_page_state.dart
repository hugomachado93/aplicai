part of 'explore_page_bloc.dart';

abstract class ExplorePageState extends Equatable {
  const ExplorePageState();

  @override
  List<Object> get props => [];
}

class ExplorePageInitial extends ExplorePageState {}

class LoadingPageState extends ExplorePageState {}

class LoadedPageState extends ExplorePageState {
  List<Demanda> demandas;

  LoadedPageState({this.demandas});

  @override
  List<Object> get props => [demandas];
}

class ClickDemandState extends ExplorePageState {
  Demanda demanda;

  ClickDemandState({this.demanda});
}
