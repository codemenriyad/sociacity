import 'package:app_ui/app_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociacity/app/routes/routes.dart';
import 'package:sociacity/auth/cubit/login_cubit.dart';
import 'package:sociacity/auth/view/auth_cheker.dart';
import 'package:sociacity/home/cubit/comment_cubit.dart';
import 'package:sociacity/home/cubit/post_cubit.dart';
import 'package:sociacity/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(FirebaseAuth.instance)),
        BlocProvider(create: (_) => PostCubit(FirebaseFirestore.instance)),
        BlocProvider(create: (_) => CommentCubit('')),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: AppColors.white),
            titleTextStyle:
                UITextStyle.headline6.copyWith(color: AppColors.white),
            backgroundColor: AppColors.blueDress,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: Routes.onGenerateRoute,
        home: AuthChecker(),
      ),
    );
  }
}
