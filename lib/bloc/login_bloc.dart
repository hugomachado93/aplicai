import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState());

  _validatePassword(LoginPasswordEvent event) {
    if (event.password.length < 6) {
      return state.copyWith(isPasswordValid: false);
    } else {
      return state.copyWith(isPasswordValid: true);
    }
  }

  _validateEmail(LoginEmailEvent event) {
    if (!event.email.contains("@")) {
      return state.copyWith(isEmailValid: false);
    } else {
      return state.copyWith(isEmailValid: true);
    }
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginPasswordEvent) {
      yield _validatePassword(event);
    } else if (event is LoginEmailEvent) {
      yield _validateEmail(event);
    }
    if (state.isEmailValid && state.isPasswordValid) {
      yield state.copyWith(isValid: true);
    } else {
      yield state.copyWith(isValid: false);
    }
  }
}
