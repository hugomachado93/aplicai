import 'dart:async';

import 'package:aplicai/service/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'signup_page_event.dart';
part 'signup_page_state.dart';

class SignupPageBloc extends Bloc<SignupPageEvent, SignupPageState> {
  SignupPageBloc() : super(SignupPageState());
  AuthService authService = AuthService();

  _validateEmail(String email) {
    if (!email.contains("@")) {
      return state.copyWith(
          errorMessage: "Email invalido",
          isEmailValid: false,
          displayErrorMessage: true);
    }
    return state.copyWith(isEmailValid: true, displayErrorMessage: false);
  }

  _validatePassword(String password) {
    if (password.length < 6) {
      return state.copyWith(
          errorMessage: "Senha invalida, deve conter ao menos 6 caracteres",
          isPasswordValid: false,
          displayErrorMessage: true);
    }
    return state.copyWith(isPasswordValid: true, displayErrorMessage: false);
  }

  @override
  Stream<SignupPageState> mapEventToState(
    SignupPageEvent event,
  ) async* {
    if (event is ValidateEmail) {
      yield _validateEmail(event.email);
    } else if (event is ValidatePassword) {
      yield _validatePassword(event.password);
    } else if (event is SignupUser) {
      if (state.isEmailValid && state.isPasswordValid) {
        yield LoadingPageState();
        final errorMessage =
            await authService.createUser(event.email, event.password);
        if (errorMessage.isEmpty) {
          yield ContinueSignup();
        } else {
          yield state.copyWith(
              errorMessage: errorMessage,
              displayErrorMessage: true,
              isEmailValid: true,
              isPasswordValid: true);
        }
      }
    } else if (event is LoginUser) {
      yield GoToLoginPage();
    }
  }
}
