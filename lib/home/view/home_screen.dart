// ignore_for_file: inference_failure_on_function_invocation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociacity/home/cubit/post_cubit.dart';
import 'package:sociacity/home/view/post_detail.dart';
import 'package:sociacity/home/view/widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const route = '/LoginScreen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PostCubit(firestore)),
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostError) {
            return Center(child: Text(state.message));
          }
          if (state is PostLoaded) {
            return state.posts.isNotEmpty
                ? ListView.builder(
                    itemCount: state.posts.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (context, index) {
                      final post = state.posts[index];
                      return PostCard(
                        callBack: () {
                          Navigator.of(context)
                              .pushNamed(PostDetailPage.route, arguments: post);
                        },
                        post: post,
                        
                      );
                    },
                  )
                : const Center(child: Text('No Posts Available'));
          }

          return const Center(child: Text('No Posts Available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Post'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter post content'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<PostCubit>().addPost(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
