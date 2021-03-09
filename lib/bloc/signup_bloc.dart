import 'dart:async';

import 'package:aplicai/entity/user_entity.dart';
import 'package:aplicai/service/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserService userService;
  SignupBloc({@required this.userService}) : super(SignupInitial());

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is SignupUserEvent) {
      yield SignupLoadingState();
      userService.saveUserData(event.userEntity);
      yield SignupLoadedState();
    }
  }
}
