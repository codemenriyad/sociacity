// ignore_for_file: avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:app_ui/app_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociacity/auth/cubit/login_cubit.dart';
import 'package:sociacity/auth/view/login_screen.dart';
import 'package:sociacity/profile/cubit/user_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              UserCubit(FirebaseFirestore.instance)..loadUserProfile(userId),
        ),
        BlocProvider(
          create: (context) => LoginBloc(FirebaseAuth.instance),
        ),
      ],
      child: ProfileView(
        userId: userId,
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      await context.read<UserCubit>().loadUserProfile(userId);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final userData = state.userData;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          '${userData['name'][0]}',
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${userData['name']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${userData['email']}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone: ${userData['phone']}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Joined: ${timeago.format((userData['createdAt'] as Timestamp).toDate())}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: AppSpacing.lg,
                      ),
                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          }
                          if (state is LoginInitial) {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginPage.route);
                          }
                        },
                        builder: (context, state) {
                          return AppButton.blueDress(
                            onPressed: () {
                              context.read<LoginBloc>().add(Logout());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (state is LoginLoading)
                                  const SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                    ),
                                  )
                                else
                                  const Text('Logout'),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No data available.'));
          },
        ),
      ),
    );
  }
}
