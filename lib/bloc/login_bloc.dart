import 'dart:async';

import 'package:aplicai/bloc/explore_page_bloc.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState());

  AuthService _authService = AuthService();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    print(event);
    if (event is LoginUserSignupEvent) {
      yield LoginLoadingState();
      yield LoginUserCreatedState();
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
    } else if (event is LoginGoogleEvent) {
      yield LoginLoadingState();
      UserLoginState userLoginState = await _authService.signInWithGoogle();
      if (userLoginState.isValid && userLoginState.isFinished) {
        yield LoginUserFinishedState();
      } else if (userLoginState.isValid && !userLoginState.isFinished) {
        yield LoginUserNotFinishedState();
      } else {
        yield state.copyWith(userLoginState: userLoginState);
      }
    }
  }
}
