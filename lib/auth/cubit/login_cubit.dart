import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._firebaseLogin) : super(LoginInitial()) {
    on<Login>(_handleLogin);
    on<Logout>(_handleLogout);
  }
  final FirebaseAuth _firebaseLogin;

  Future<void> _handleLogin(Login event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final userCredential = await _firebaseLogin.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(LoginLoaded(user: userCredential.user!));
    } on FirebaseAuthException catch (e) {
      return emit(LoginError(error: e.code));
    }
  }

  Future<void> _handleLogout(Logout event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    await _firebaseLogin.signOut();
    emit(LoginInitial());
  }
}
