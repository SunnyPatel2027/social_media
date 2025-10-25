import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/common_snackbar.dart';
import '../../../core/constants/route_names.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.error != null) showSnackBar(context, state.error!);
              if (state.user != null) context.go(RouteNames.post);
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passCtrl,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => auth.signUp(
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                        usernameCtrl.text.trim(),
                      ),
                      child: const Text('Create Account'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go(RouteNames.login),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
