import 'dart:async';

import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'em_andamento_event.dart';
part 'em_andamento_state.dart';

class EmAndamentoBloc extends Bloc<EmAndamentoEvent, EmAndamentoState> {
  UserService userService;
  EmAndamentoBloc({@required this.userService}) : super(EmAndamentoInitial());

  @override
  Stream<EmAndamentoState> mapEventToState(
    EmAndamentoEvent event,
  ) async* {
    if (event is GetUserData) {
      yield EmAndamentoLoading();
      yield await userService.getUserDemandsAndType();
    }
  }
}
