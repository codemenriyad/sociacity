part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  SignupFailure(this.error);
  final String error;


  @override
  List<Object?> get props => [error];
}
