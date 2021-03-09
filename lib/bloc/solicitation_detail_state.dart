part of 'solicitation_detail_bloc.dart';

abstract class SolicitationDetailState extends Equatable {
  const SolicitationDetailState();

  @override
  List<Object> get props => [];
}

class SolicitationDetailInitial extends SolicitationDetailState {}

class SolicitationDetailLoading extends SolicitationDetailState {}

class SolicitationDetailLoaded extends SolicitationDetailState {
  Solicitation solicitation;
  SolicitationDetailLoaded({this.solicitation});

  @override
  List<Object> get props => [solicitation];
}

class SolicitationAcceptState extends SolicitationDetailState {}

class SolicitationRejectState extends SolicitationDetailState {}
