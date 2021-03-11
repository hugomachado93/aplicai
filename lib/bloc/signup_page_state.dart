part of 'signup_page_bloc.dart';

class SignupPageState extends Equatable {
  final String email;
  final bool isEmailValid;
  final String password;
  final bool isPasswordValid;
  final String errorMessage;
  final bool displayErrorMessage;

  const SignupPageState(
      {this.email,
      this.password,
      this.errorMessage = "",
      this.isEmailValid = false,
      this.isPasswordValid = false,
      this.displayErrorMessage = false});

  SignupPageState copyWith(
      {String email,
      String password,
      String errorMessage,
      bool isEmailValid,
      bool isPasswordValid,
      bool displayErrorMessage}) {
    return SignupPageState(
        email: email ?? this.email,
        password: password ?? this.password,
        errorMessage: errorMessage ?? this.errorMessage,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        displayErrorMessage: displayErrorMessage ?? this.displayErrorMessage);
  }

  @override
  List<Object> get props =>
      [email, password, errorMessage, isEmailValid, isPasswordValid];
}

class LoadingPageState extends SignupPageState {}

class ContinueSignup extends SignupPageState {}

class GoToLoginPage extends SignupPageState {}
