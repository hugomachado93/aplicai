import 'dart:async';

import 'package:aplicai/bloc/login_bloc.dart';
import 'package:aplicai/service/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signin_page_event.dart';
part 'signin_page_state.dart';

class SignupPageBloc extends Bloc<SignupPageEvent, SignupPageState> {
  SignupPageBloc() : super(SignupPageInitial());
  AuthService authService = AuthService();

  @override
  Stream<SignupPageState> mapEventToState(
    SignupPageEvent event,
  ) async* {
    if (event is ClickSignupEvent) {
      yield LoadingSignupPage();
      LoadedSignupPage loadedSigninPage =
          await authService.createUser(event.email, event.password);
      yield loadedSigninPage;
    }
  }
}
