part of 'signup_cubit.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  SignupSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
  final String name;
  final String email;
  final String phone;
  final String password;


  @override
  List<Object?> get props => [name, email, phone, password];
}
