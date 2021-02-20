part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isPasswordValid;
  final bool isEmailValid;
  final bool isValid;

  const LoginState({this.isEmailValid = false, this.isPasswordValid = false, this.isValid = false});

  copyWith({bool isPasswordValid, bool isEmailValid, bool isValid}) {
    return LoginState(
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isValid: isValid ?? this.isValid);
  }

  @override
  List<Object> get props => [isPasswordValid, isEmailValid, isValid];
}
