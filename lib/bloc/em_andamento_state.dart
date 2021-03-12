part of 'em_andamento_bloc.dart';

abstract class EmAndamentoState extends Equatable {
  const EmAndamentoState();

  @override
  List<Object> get props => [];
}

class EmAndamentoInitial extends EmAndamentoState {}

class EmAndamentoLoading extends EmAndamentoState {}

class EmAndamentoLoaded extends EmAndamentoState {
  final List<Demanda> demands;
  final String type;

  EmAndamentoLoaded({this.demands, this.type});

  @override
  List<Object> get props => [demands, type];
}

class EmAndamentoError extends EmAndamentoState {}
