import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.watch(authViewModelProvider);
    final state = authViewModel.state;
    final isLoading = state.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signUpEmailField'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('signUpPasswordField'),
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('signUpPrimaryButton'),
                onPressed: isLoading
                    ? null
                    : () async {
                        await authViewModel.signUpWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Criar conta'),
              ),
              const SizedBox(height: 8),
              if (state.status == AuthStatus.failure && state.message != null)
                Text(
                  state.message!,
                  key: const Key('signUpErrorText'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const Spacer(),
              TextButton(
                key: const Key('signUpNavigateToSignInButton'),
                onPressed: () => context.go(AppRoutes.signInPath),
                child: const Text('Já tem conta? Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
