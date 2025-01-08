import 'package:app_ui/app_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociacity/auth/cubit/signup_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static const route = '/signupScreen';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupBloc(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
      ],
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup Successful')),
            );
            Navigator.pop(context);
          } else if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Name is required' : null,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) =>
                      value!.isEmpty ? 'Phone is required' : null,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) => value!.isEmpty
                      ? 'Password is required!'
                      : value.length < 6
                          ? 'Password too short'
                          : null,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm password is required!';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppButton.blueDress(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<SignupBloc>().add(
                            SignupSubmitted(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              password: passwordController.text,
                            ),
                          );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is SignupLoading)
                        const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                          ),
                        )
                      else
                        const Text('Signup'),
                    ],
                  ),
                ),
                // const SizedBox(height: 40),
                // AppButton.transparentWhite(
                //   onPressed: () {
                //     Navigator.of(context).pushNamed(LoginPage.route);
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         'Already have an account?',
                //         style: UITextStyle.bodyText2.copyWith(
                //           color: AppColors.grey,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       Text(
                //         ' Login',
                //         style: UITextStyle.bodyText2.copyWith(
                //           color: AppColors.black,
                //           fontWeight: FontWeight.w800,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
