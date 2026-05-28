import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/presentation/localization/auth_failure_localizer.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flowdelivery_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:flowdelivery_app/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _localValidationMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(authViewModelProvider).resetPasswordResetState();
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.read(authViewModelProvider);
    final passwordResetStatus = ref.watch(
      authViewModelProvider.select((vm) => vm.state.passwordResetStatus),
    );
    final passwordResetFailure = ref.watch(
      authViewModelProvider.select((vm) => vm.state.passwordResetFailure),
    );
    final isLoading = passwordResetStatus == PasswordResetStatus.loading;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return AuthPageShell(
      icon: Icons.lock_reset,
      title: l10n.authResetPasswordTitle,
      subtitle: l10n.authResetPasswordSubtitle,
      activeTab: AuthPageTab.reports,
      onTapSignIn: () => context.go(AppRoutes.signInPath),
      onTapSignUp: () => context.go(AppRoutes.signUpPath),
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.authPasswordLabel,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const Key('resetPasswordPasswordField'),
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: l10n.authResetPasswordPasswordHint,
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
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.authResetPasswordConfirmLabel,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const Key('resetPasswordConfirmPasswordField'),
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmation,
            decoration: InputDecoration(
              hintText: l10n.authResetPasswordConfirmHint,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmation = !_obscureConfirmation;
                  });
                },
                icon: Icon(
                  _obscureConfirmation
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
      primaryAction: FilledButton(
        key: const Key('resetPasswordPrimaryButton'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
        onPressed: isLoading ? null : () => _submit(authViewModel, l10n),
        child: isLoading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Text(
                l10n.authResetPasswordPrimaryAction,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
      ),
      statusBanner: _statusBanner(
        context,
        passwordResetStatus,
        passwordResetFailure,
        l10n,
      ),
      socialSection: TextButton(
        key: const Key('resetPasswordBackToSignInButton'),
        onPressed: () => context.go(AppRoutes.signInPath),
        child: Text(l10n.authResetPasswordBackAction),
      ),
      legalText: AuthLegalText(
        leadingText: l10n.authForgotPasswordLegalLeading,
      ),
    );
  }

  Widget? _statusBanner(
    BuildContext context,
    PasswordResetStatus passwordResetStatus,
    AuthFailure? passwordResetFailure,
    AppLocalizations l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_localValidationMessage case final message?) {
      return AuthStatusBanner(
        key: const Key('resetPasswordFeedbackBanner'),
        message: message,
        icon: Icons.error_outline,
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
      );
    }

    if (passwordResetStatus == PasswordResetStatus.failure &&
        passwordResetFailure != null) {
      return AuthStatusBanner(
        key: const Key('resetPasswordFeedbackBanner'),
        message: passwordResetFailure.localized(l10n),
        icon: Icons.error_outline,
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
      );
    }

    if (passwordResetStatus == PasswordResetStatus.success) {
      return AuthStatusBanner(
        key: const Key('resetPasswordFeedbackBanner'),
        message: l10n.authResetPasswordSuccess,
        icon: Icons.check_circle_outline,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      );
    }

    return null;
  }

  Future<void> _submit(
    AuthViewModel authViewModel,
    AppLocalizations l10n,
  ) async {
    final password = _passwordController.text;
    final confirmation = _confirmPasswordController.text;

    if (password.isEmpty) {
      setState(() {
        _localValidationMessage = l10n.authResetPasswordEmptyPasswordError;
      });
      return;
    }

    if (password != confirmation) {
      setState(() {
        _localValidationMessage = l10n.authResetPasswordMismatchError;
      });
      return;
    }

    setState(() {
      _localValidationMessage = null;
    });
    await authViewModel.updatePassword(password: password);
  }
}
