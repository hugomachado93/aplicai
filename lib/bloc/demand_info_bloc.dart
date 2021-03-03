import 'dart:async';

import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'demand_info_event.dart';
part 'demand_info_state.dart';

class DemandInfoBloc extends Bloc<DemandInfoEvent, DemandInfoState> {
  DemandInfoBloc() : super(DemandInfoInitial());
  UserService userService = UserService();

  @override
  Stream<DemandInfoState> mapEventToState(
    DemandInfoEvent event,
  ) async* {
    if (event is GetAllUsers) {
      DemandInfoAllUsers demandInfoAllUsers = await userService
          .getAllUsersFromProject(event.employerId, event.studentUserListId);
      yield demandInfoAllUsers;
    }
  }
}
