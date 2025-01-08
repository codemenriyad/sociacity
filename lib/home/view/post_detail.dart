// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociacity/home/cubit/comment_cubit.dart';
import 'package:sociacity/home/cubit/post_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({required this.post, super.key});
  final Map<String, dynamic> post;
  static const route = 'postDetail';

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CommentCubit('${widget.post['id']}')),
      ],
      child: PostDetailView(
        post: widget.post,
      ),
    );
  }
}

class PostDetailView extends StatefulWidget {
  const PostDetailView({required this.post, super.key});
  final Map<String, dynamic> post;
  static const route = 'postDetail';

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
    String formatTimestamp(Timestamp timestamp) {
      final dateTime = timestamp.toDate();

      return timeago.format(dateTime);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.post['userName']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatTimestamp(widget.post['timestamp'] as Timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.post['content']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text('Comments:'),
          ),
          Expanded(
            child: BlocConsumer<CommentCubit, CommentState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is CommentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CommentError) {
                  return Center(child: Text(state.errorMessage));
                }

                if (state is CommentLoaded) {
                  if (state.comments.isEmpty) {
                    return const Center(child: Text('No comments yet.'));
                  }

                  return ListView.builder(
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];

                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${comment.userName}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${comment.commentText}'),
                          ],
                        ),
                        subtitle: Text(
                          'Posted on: ${timeago.format(comment.timestamp)}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text('No comments yet.'));
              },
            ),
          ),

          // Add Comment Input
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                BlocConsumer<PostCubit, PostState>(
                  listener: (context, state) {
                    if (state is PostLoading) {
                    }

                    if (state is PostCommentAdded) {
                      commentController.clear();
                      context
                          .read<CommentCubit>()
                          .loadComments('${widget.post['id']}');
                    }

                    if (state is PostError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${state.message}')));
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () async {
                        final comment = commentController.text.trim();
                        if (comment.isNotEmpty) {
                          // Add the comment to Firestore
                          await context.read<PostCubit>().addComment(
                                '${widget.post['id']}',
                                comment,
                              );
                        }
                      },
                      child: Row(
                        children: [
                          if (state is PostLoading)
                            const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: AppColors.blueDress,
                              ),
                            )
                          else
                            const Text('Post'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
