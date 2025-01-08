import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sociacity/app/app.dart';
import 'package:sociacity/bootstrap.dart';
import 'package:sociacity/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(() => const App());
}
