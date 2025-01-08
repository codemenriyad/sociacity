// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this._firestore) : super(PostLoading()) {
    loadPosts();
  }

  final FirebaseFirestore _firestore;
  final _auth = FirebaseAuth.instance;

  Future<void> loadPosts() async {
    emit(PostLoading());
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();
               
      final postsWithUserNames = await Future.wait(
        snapshot.docs.map((doc) async {
          final post = doc.data()! as Map<String, dynamic>;
          final userId = post['userId'];

          final userSnapshot =
              await _firestore.collection('users').doc('$userId').get();
          final userName = userSnapshot.exists
              ? userSnapshot['name'] ?? 'Unknown'
              : 'Unknown';

          return {
            'id': doc.id,
            'content': post['content'] ?? 'No Content',
            'timestamp': post['timestamp'] ?? FieldValue.serverTimestamp(),
            'userName': userName,
          };
        }),
      );

      emit(PostLoaded(postsWithUserNames));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> addPost(String content) async {
    try {
      PostLoading();
      final userId = _auth.currentUser;
      await _firestore.collection('posts').add({
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId!.uid,
      });
      emit(PostAdded());
      await loadPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> addComment(String postId, String comment) async {
    try {
      emit(PostLoading());
      final userId = _auth.currentUser!.uid;
      final userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      final userName =
          userSnapshot.exists ? userSnapshot['name'] ?? 'Unknown' : 'Unknown';
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'comment': comment,
        'userId': userId,
        'userName': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(PostCommentAdded());
      await loadPosts();
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
