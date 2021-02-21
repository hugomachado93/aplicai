part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginEmailEvent extends LoginEvent {
  final String email;

  LoginEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class LoginPasswordEvent extends LoginEvent {
  final String password;

  LoginPasswordEvent(this.password);

  @override
  List<Object> get props => [password];
}

class LoginUserSignupEvent extends LoginEvent {
  String email;
  String password;

  LoginUserSignupEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
