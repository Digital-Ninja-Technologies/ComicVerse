import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/input_validators.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.status == AuthStatus.failure &&
                      state.message != null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message!)));
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('ComicVerse',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text('Read anywhere. Resume everywhere.',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 32),
                        TextFormField(
                            controller: _email,
                            validator: InputValidators.email,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                const InputDecoration(labelText: 'Email')),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: _password,
                            validator: InputValidators.password,
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Password')),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () =>
                                    context.push('/forgot-password'),
                                child: const Text('Forgot password?'))),
                        FilledButton(
                          onPressed: state.isLoading ? null : _submit,
                          child: state.isLoading
                              ? const CircularProgressIndicator.adaptive()
                              : const Text('Log in'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                            onPressed: () => context
                                .read<AuthBloc>()
                                .add(AuthGoogleRequested()),
                            icon: const Icon(Icons.g_mobiledata_rounded),
                            label: const Text('Continue with Google')),
                        TextButton(
                            onPressed: () => context
                                .read<AuthBloc>()
                                .add(AuthGuestRequested()),
                            child: const Text('Continue as guest')),
                        TextButton(
                            onPressed: () => context.push('/register'),
                            child: const Text('Create an account')),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(AuthLoginRequested(_email.text.trim(), _password.text));
    }
  }
}
