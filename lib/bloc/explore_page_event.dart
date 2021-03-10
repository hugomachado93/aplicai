part of 'explore_page_bloc.dart';

abstract class ExplorePageEvent extends Equatable {
  const ExplorePageEvent();

  @override
  List<Object> get props => [];
}

class GetActiveDemands extends ExplorePageEvent {}

class ClickDemand extends ExplorePageEvent {
  Demanda demanda;

  ClickDemand({this.demanda});

  @override
  List<Object> get props => [demanda];
}
