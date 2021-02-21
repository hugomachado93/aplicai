import 'dart:async';

import 'package:aplicai/service/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState());

  AuthService _authService = AuthService();

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
    } else if (event is LoginUserSignupEvent) {
      yield LoginLoadingState();
      final UserLoginState userLoginState =
          await _authService.createUser(event.email, event.password);
      if (userLoginState.isValid) {
        yield LoginUserCreatedState();
      } else {
        yield state.copyWith(userLoginState: userLoginState);
      }
    } else if (event is LoginUserSigninEvent) {
      yield LoginLoadingState();
      final UserLoginState userLoginState =
          await _authService.signinUser(event.email, event.password);
      if (userLoginState.isValid && userLoginState.isFinished) {
        yield LoginUserFinishedState();
      } else if (userLoginState.isValid && !userLoginState.isFinished) {
        yield LoginUserNotFinishedState();
      } else {
        yield state.copyWith(userLoginState: userLoginState);
      }
    }

    if (state.isEmailValid && state.isPasswordValid) {
      yield state.copyWith(isValid: true);
    } else {
      yield state.copyWith(isValid: false);
    }
  }
}
