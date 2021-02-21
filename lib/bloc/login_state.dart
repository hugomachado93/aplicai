part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isPasswordValid;
  final bool isEmailValid;
  final bool isValid;
  final SignupError signupError;

  const LoginState(
      {this.isEmailValid = true,
      this.isPasswordValid = true,
      this.isValid = false,
      this.signupError = const SignupError(isValid: true)});

  copyWith(
      {bool isPasswordValid,
      bool isEmailValid,
      bool isValid,
      SignupError signupError}) {
    return LoginState(
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isValid: isValid ?? this.isValid,
        signupError: signupError ?? this.signupError);
  }

  @override
  List<Object> get props =>
      [isPasswordValid, isEmailValid, isValid, signupError];
}

class LoginInitState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginUserCreatedState extends LoginState {
  @override
  List<Object> get props => [];
}

class SignupError {
  final bool isValid;
  final String message;

  const SignupError({this.isValid = false, this.message});
}
