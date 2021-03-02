part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileStudent extends UserProfileState {
  final UserEntity userEntity;
  UserProfileStudent({this.userEntity});

  @override
  List<Object> get props => [userEntity];
}

class UserProfileEmployer extends UserProfileState {
  final Empreendedor empreendedor;
  UserProfileEmployer({this.empreendedor});

  @override
  List<Object> get props => [empreendedor];
}
