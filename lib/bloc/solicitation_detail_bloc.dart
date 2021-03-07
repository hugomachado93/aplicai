import 'dart:async';

import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/solicitation.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'solicitation_detail_event.dart';
part 'solicitation_detail_state.dart';

class SolicitationDetailBloc
    extends Bloc<SolicitationDetailEvent, SolicitationDetailState> {
  SolicitationDetailBloc() : super(SolicitationDetailInitial());
  UserService userService = UserService();

  @override
  Stream<SolicitationDetailState> mapEventToState(
    SolicitationDetailEvent event,
  ) async* {
    if (event is GetUserSolicitationEvent) {
      yield SolicitationDetailLoading();
      Solicitation solicitation =
          await userService.getUserSolicitation(event.demanda);
      yield SolicitationDetailLoaded(solicitation: solicitation);
    } else if (event is AcceptSolicitationEvent) {
      yield SolicitationDetailLoading();
      await userService.updateParticipantsOfDemand(event.demanda);
      yield SolicitationAcceptState();
    }
  }
}
