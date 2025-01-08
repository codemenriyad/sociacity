import 'package:api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit(this.postId) : super(CommentLoading()){
    loadComments(postId);
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final String postId;
  Future<void> loadComments(String postId) async {
    try {
      emit(CommentLoading());

      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final comments = snapshot.docs.map((doc) {
          final data = doc.data();
          return Comment(
            userName: data['userName'],
            commentText: data['comment'],
            timestamp: (data['timestamp'] as Timestamp).toDate(),
          );
        }).toList();

        emit(CommentLoaded(comments));
      } else {
        emit(CommentLoaded([]));
      }
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
