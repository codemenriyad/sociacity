part of 'post_cubit.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  PostLoaded(this.posts);
    final List<Map<String, dynamic>> posts; 
}

class PostError extends PostState {
  PostError(this.message);
  final String message;
}

class PostCommentAdded extends PostState {}

class PostAdded extends PostState {}
