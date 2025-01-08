part of 'post_cubit.dart';

abstract class PostEvent {}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  AddPost(this.content);
  final String content;
}

class AddComment extends PostEvent {
  AddComment(this.postId, this.comment);
  final String postId;
  final String comment;
}
