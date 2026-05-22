import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/auth/presentation/localization/auth_failure_localizer.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flowdelivery_app/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return AuthPageShell(
      icon: Icons.delivery_dining,
      title: l10n.authSignUpTitle,
      subtitle: l10n.authSignUpSubtitle,
      activeTab: AuthPageTab.signUp,
      onTapSignIn: () => context.go(AppRoutes.signInPath),
      onTapSignUp: () {},
      signInButtonKey: const Key('signUpNavigateToSignInButton'),
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.authEmailLabel,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const Key('signUpEmailField'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: l10n.authEmailHint,
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.authPasswordLabel,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const Key('signUpPasswordField'),
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: l10n.authSignUpPasswordHint,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
      primaryAction: FilledButton(
        key: const Key('signUpPrimaryButton'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
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
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(l10n.authSignUpPrimaryAction),
      ),
      statusBanner: state.status == AuthStatus.failure && state.failure != null
          ? AuthStatusBanner(
              key: const Key('signUpErrorText'),
              message: state.failure!.localized(l10n),
              icon: Icons.error_outline,
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
            )
          : state.status == AuthStatus.authenticated
              ? AuthStatusBanner(
                  message: l10n.authSignUpSuccess,
                  icon: Icons.check_circle_outline,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                )
              : null,
      socialSection: const AuthSocialSection(),
      legalText: AuthLegalText(
        leadingText: l10n.authSignUpLegalLeading,
      ),
    );
  }
}
