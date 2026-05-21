import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
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
      appBar: AppBar(title: const Text('Entrar')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('signInEmailField'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('signInPasswordField'),
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('signInPrimaryButton'),
                onPressed: isLoading
                    ? null
                    : () async {
                        await authViewModel.signInWithEmailAndPassword(
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
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 8),
              if (state.status == AuthStatus.failure && state.message != null)
                Text(
                  state.message!,
                  key: const Key('signInErrorText'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const Spacer(),
              TextButton(
                key: const Key('signInNavigateToSignUpButton'),
                onPressed: () => context.go(AppRoutes.signUpPath),
                child: const Text('Não tem conta? Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
