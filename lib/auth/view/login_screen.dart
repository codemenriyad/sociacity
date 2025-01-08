import 'package:app_ui/app_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociacity/auth/cubit/login_cubit.dart';
import 'package:sociacity/auth/view/signup_screen.dart';
import 'package:sociacity/bottomnavigation/view/bottom_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const route = '/LoginScreen';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(FirebaseAuth.instance)),
      ],
      child: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is LoginLoaded) {
            Navigator.of(context)
                .pushReplacementNamed(BottomNavigationScreen.route);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) =>
                        value!.length < 6 ? 'Password too short' : null,
                  ),
                  const SizedBox(height: 40),
                  AppButton.blueDress(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(
                              Login(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      }
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
                          const Text('Login'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  AppButton.transparentWhite(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignupPage.route);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account? ",
                          style: UITextStyle.bodyText2.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Signup',
                          style: UITextStyle.bodyText2.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
