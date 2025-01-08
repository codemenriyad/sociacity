part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  const LoginLoaded({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

class LoginError extends LoginState {
  const LoginError({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}
