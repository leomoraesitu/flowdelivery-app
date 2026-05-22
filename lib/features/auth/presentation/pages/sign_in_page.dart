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

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
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
      icon: Icons.restaurant,
      title: l10n.authSignInTitle,
      subtitle: l10n.authSignInSubtitle,
      activeTab: AuthPageTab.signIn,
      onTapSignIn: () {},
      onTapSignUp: () => context.go(AppRoutes.signUpPath),
      signUpButtonKey: const Key('signInNavigateToSignUpButton'),
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.authEmailLabel,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const Key('signInEmailField'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: l10n.authEmailHint,
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.authPasswordLabel,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                key: const Key('signInForgotPasswordButton'),
                onPressed: () => context.go(AppRoutes.forgotPasswordPath),
                child: Text(
                  l10n.authForgotPasswordCta,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const Key('signInPasswordField'),
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: l10n.authSignInPasswordHint,
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
        key: const Key('signInPrimaryButton'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
        onPressed: isLoading
            ? null
            : () async {
                await authViewModel.signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                );
              },
        child: isLoading
          ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Text(l10n.authSignInPrimaryAction, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      statusBanner: state.status == AuthStatus.failure && state.failure != null
          ? AuthStatusBanner(
              key: const Key('signInErrorText'),
              message: state.failure!.localized(l10n),
              icon: Icons.error_outline,
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
            )
          : state.status == AuthStatus.authenticated
              ? AuthStatusBanner(
                  message: l10n.authSignInSuccess,
                  icon: Icons.check_circle_outline,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                )
              : null,
      socialSection: const AuthSocialSection(),
      legalText: AuthLegalText(
        leadingText: l10n.authSignInLegalLeading,
      ),
    );
  }
}
