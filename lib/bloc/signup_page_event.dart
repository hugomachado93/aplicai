part of 'signup_page_bloc.dart';

abstract class SignupPageEvent extends Equatable {
  const SignupPageEvent();

  @override
  List<Object> get props => [];
}

class ValidateEmail extends SignupPageEvent {
  String email;

  ValidateEmail({this.email});

  @override
  List<Object> get props => [email];
}

class ValidatePassword extends SignupPageEvent {
  String password;

  ValidatePassword({this.password});

  @override
  List<Object> get props => [password];
}

class SignupUser extends SignupPageEvent {
  String email;
  String password;

  SignupUser({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class LoginUser extends SignupPageEvent {}
