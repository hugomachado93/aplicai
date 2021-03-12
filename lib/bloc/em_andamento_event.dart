part of 'em_andamento_bloc.dart';

abstract class EmAndamentoEvent extends Equatable {
  const EmAndamentoEvent();

  @override
  List<Object> get props => [];
}

class GetUserData extends EmAndamentoEvent {}
