part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isPasswordValid;
  final bool isEmailValid;
  final bool isValid;
  final UserLoginState userLoginState;

  const LoginState({
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isValid = false,
    this.userLoginState =
        const UserLoginState(isValid: true, isFinished: false),
  });

  copyWith(
      {bool isPasswordValid,
      bool isEmailValid,
      bool isValid,
      UserLoginState userLoginState}) {
    return LoginState(
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isValid: isValid ?? this.isValid,
        userLoginState: userLoginState ?? this.userLoginState);
  }

  @override
  List<Object> get props =>
      [isPasswordValid, isEmailValid, isValid, userLoginState];
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

class LoginUserFinishedState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginUserNotFinishedState extends LoginState {
  @override
  List<Object> get props => [];
}

class UserLoginState {
  final bool isValid;
  final bool isFinished;
  final String message;

  const UserLoginState({this.isValid = false, this.isFinished, this.message});
}
