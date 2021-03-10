part of 'signin_page_bloc.dart';

abstract class SignupPageEvent extends Equatable {
  const SignupPageEvent();

  @override
  List<Object> get props => [];
}

class ClickSignupEvent extends SignupPageEvent {
  String email;
  String password;

  ClickSignupEvent({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}
