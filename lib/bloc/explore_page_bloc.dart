import 'dart:async';

import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/service/demand_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'explore_page_event.dart';
part 'explore_page_state.dart';

class ExplorePageBloc extends Bloc<ExplorePageEvent, ExplorePageState> {
  DemandService demandService;
  ExplorePageBloc({@required this.demandService}) : super(ExplorePageInitial());

  @override
  Stream<ExplorePageState> mapEventToState(
    ExplorePageEvent event,
  ) async* {
    if (event is GetActiveDemands) {
      yield LoadingPageState();
      final demands = await demandService.getActiveDemands();
      yield LoadedPageState(demandas: demands);
    } else if (event is ClickDemand) {
      yield ClickDemandState(demanda: event.demanda);
    }
  }
}
