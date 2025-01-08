// ignore_for_file: use_if_null_to_convert_nulls_to_bools, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sociacity/auth/view/login_screen.dart';
import 'package:sociacity/bottomnavigation/view/bottom_navigation.dart';

/// AuthChecker redirects the user based on login state
class AuthChecker extends StatelessWidget {
  AuthChecker({super.key});
  static const route = '/';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if the user is logged in
  Future<bool> checkUserLoggedIn() async {
    final user = _auth.currentUser;
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data == true) {
          return const BottomNavigationScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
