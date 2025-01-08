part of 'user_cubit.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  UserLoaded(this.userData);

  final Map<String, dynamic> userData;
}

class UserError extends UserState {
  UserError(this.message);

  final String message;
}
