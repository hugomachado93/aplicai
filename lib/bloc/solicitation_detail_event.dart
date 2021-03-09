part of 'solicitation_detail_bloc.dart';

abstract class SolicitationDetailEvent extends Equatable {
  const SolicitationDetailEvent();

  @override
  List<Object> get props => [];
}

class GetUserSolicitationEvent extends SolicitationDetailEvent {
  Demanda demanda;

  GetUserSolicitationEvent({this.demanda});

  @override
  List<Object> get props => [demanda];
}

class AcceptSolicitationEvent extends SolicitationDetailEvent {
  Demanda demanda;

  AcceptSolicitationEvent({this.demanda});

  @override
  List<Object> get props => [demanda];
}

class RejectSolicitationEvent extends SolicitationDetailEvent {
  Demanda demanda;

  RejectSolicitationEvent({this.demanda});

  @override
  List<Object> get props => [demanda];
}
