import 'dart:async';

import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'demand_info_explore_event.dart';
part 'demand_info_explore_state.dart';

class DemandInfoExploreBloc
    extends Bloc<DemandInfoExploreEvent, DemandInfoExploreState> {
  DemandInfoExploreBloc() : super(DemandInfoExploreInitial());
  UserService userService = UserService();

  @override
  Stream<DemandInfoExploreState> mapEventToState(
    DemandInfoExploreEvent event,
  ) async* {
    if (event is GetCurrentUserAndEmployerData) {
      try {
        yield DemandInfoExploreLoading();
        yield await userService.getCurrentUserAndEmployerData(event.employerId);
      } catch (err) {
        print(err);
        yield DemandInfoExploreError();
      }
    } else if (event is GoToEmployerPerfil) {
      yield DemandInfoExploreEmployerPerfil(empreendedor: event.empreendedor);
    }
  }
}
