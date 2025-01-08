part of 'comment_cubit.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  CommentLoaded(this.comments);
  final List<Comment> comments;

}

class CommentError extends CommentState {
  CommentError(this.errorMessage);
  final String errorMessage;

}

