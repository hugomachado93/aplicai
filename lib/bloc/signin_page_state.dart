part of 'signin_page_bloc.dart';

abstract class SignupPageState extends Equatable {
  const SignupPageState();

  @override
  List<Object> get props => [];
}

class SignupPageInitial extends SignupPageState {}

class LoadingSignupPage extends SignupPageState {}

class LoadedSignupPage extends SignupPageState {
  bool isValid;
  String message;

  LoadedSignupPage({this.isValid, this.message});
  @override
  List<Object> get props => [isValid, message];
}
