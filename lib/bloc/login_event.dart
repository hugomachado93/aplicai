part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginUserSignupEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoginUserSigninEvent extends LoginEvent {
  String email;
  String password;

  LoginUserSigninEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LoginGoogleEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}
