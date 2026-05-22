import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/auth/presentation/localization/auth_failure_localizer.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/widgets/auth_page_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  String? _feedbackMessage;
  bool _feedbackIsError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.watch(authViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return AuthPageShell(
      icon: Icons.mark_email_read_outlined,
      title: l10n.authForgotPasswordTitle,
      subtitle: l10n.authForgotPasswordSubtitle,
      activeTab: AuthPageTab.reports,
      onTapSignIn: () => context.go(AppRoutes.signInPath),
      onTapSignUp: () => context.go(AppRoutes.signUpPath),
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.authEmailLabel,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const Key('forgotPasswordEmailField'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: l10n.authEmailHint,
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.authForgotPasswordHelper,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Text(
              l10n.authForgotPasswordPlaceholderInfo,
              style: textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      primaryAction: FilledButton(
        key: const Key('forgotPasswordPrimaryButton'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ),
        onPressed: _isSubmitting
            ? null
            : () async {
                final email = _emailController.text.trim();

                if (email.isEmpty) {
                  setState(() {
                    _feedbackIsError = true;
                    _feedbackMessage = l10n.authForgotPasswordEmptyEmailError;
                  });
                  return;
                }

                setState(() {
                  _isSubmitting = true;
                  _feedbackMessage = null;
                });

                final error = await authViewModel.sendPasswordRecoveryEmail(
                  email: email,
                );

                if (!mounted) {
                  return;
                }

                setState(() {
                  _isSubmitting = false;
                  if (error != null) {
                    _feedbackIsError = true;
                    _feedbackMessage = error.localized(l10n);
                  } else {
                    _feedbackIsError = false;
                    _feedbackMessage = l10n.authForgotPasswordSuccess;
                  }
                });
              },
        child: _isSubmitting
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(l10n.authForgotPasswordPrimaryAction),
      ),
      statusBanner: _feedbackMessage == null
          ? AuthStatusBanner(
              message: l10n.authForgotPasswordDefaultBanner,
              icon: Icons.info_outline,
              backgroundColor: colorScheme.tertiaryContainer,
              foregroundColor: colorScheme.onTertiaryContainer,
            )
          : AuthStatusBanner(
              key: const Key('forgotPasswordFeedbackBanner'),
              message: _feedbackMessage!,
              icon: _feedbackIsError ? Icons.error_outline : Icons.check_circle_outline,
              backgroundColor: _feedbackIsError
                  ? colorScheme.errorContainer
                  : colorScheme.primaryContainer,
              foregroundColor: _feedbackIsError
                  ? colorScheme.onErrorContainer
                  : colorScheme.onPrimaryContainer,
            ),
      socialSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            key: const Key('forgotPasswordBackToSignInButton'),
            onPressed: () => context.go(AppRoutes.signInPath),
            child: Text(l10n.authForgotPasswordBackAction),
          ),
        ],
      ),
      legalText: AuthLegalText(
        leadingText: l10n.authForgotPasswordLegalLeading,
      ),
    );
  }
}