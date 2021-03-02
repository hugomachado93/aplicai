import 'dart:async';

import 'package:aplicai/entity/empreendedor.dart';
import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial());

  UserService userService = UserService();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is GetUserTypeProfile) {
      String type = await userService.getUserTypeFuture();
      if (type == 'employer') {
        Empreendedor empreendedor =
            await userService.getUserEmpolyerAndFinishedDemands();
        yield UserProfileEmployer(empreendedor: empreendedor);
      } else {
        UserEntity userEntity =
            await userService.getUserStudentAndFinishedDemands();
        yield UserProfileStudent(userEntity: userEntity);
      }
    }
  }
}
