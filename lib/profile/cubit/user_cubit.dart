import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._firestore) : super(UserInitial());

  final FirebaseFirestore _firestore;

  Future<void> loadUserProfile(String userId) async {
    emit(UserLoading());
    try {
      final userSnapshot = await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        emit(UserLoaded(userSnapshot.data()!));
      } else {
        emit(UserError('User not found'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
