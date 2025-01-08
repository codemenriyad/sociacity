import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc(this._auth, this._firestore) : super(SignupInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignupLoading());
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': event.name,
          'email': event.email,
          'phone': event.phone,
          'createdAt': Timestamp.now(),
        });

        emit(SignupSuccess());
      } on FirebaseAuthException catch (e) {
        log('aklfskfhjsd ${e.code}');
        return emit(SignupFailure(e.code));
      }
    });
  }
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
}
