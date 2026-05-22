import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/auth/presentation/localization/auth_failure_localizer.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flowdelivery_app/features/auth/presentation/viewmodels/auth_view_model.dart';
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
  late final AuthViewModel _authViewModel;
  bool _didResetRecoveryState = false;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _authViewModel = ref.read(authViewModelProvider);
    Future<void>(() {
      if (!mounted) {
        return;
      }

      _authViewModel.resetPasswordRecoveryState();
      setState(() {
        _didResetRecoveryState = true;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider.select((value) => value.state));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final isSubmitting =
        state.passwordRecoveryStatus == PasswordRecoveryStatus.loading;
    final bannerData = _buildBannerData(
      l10n: l10n,
      colorScheme: colorScheme,
      state: state,
      validationMessage: _validationMessage,
    );

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
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ),
        onPressed: isSubmitting
            ? null
            : () async {
                final email = _emailController.text.trim();

                if (email.isEmpty) {
                  setState(() {
                    _validationMessage = l10n.authForgotPasswordEmptyEmailError;
                  });
                  return;
                }

                setState(() {
                  _validationMessage = null;
                });

                await _authViewModel.sendPasswordRecoveryEmail(
                  email: email,
                );
              },
        child: isSubmitting
          ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.onPrimary,
                ),
              )
            : Text(l10n.authForgotPasswordPrimaryAction, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      statusBanner: AuthStatusBanner(
        key: bannerData.key,
        message: bannerData.message,
        icon: bannerData.icon,
        backgroundColor: bannerData.backgroundColor,
        foregroundColor: bannerData.foregroundColor,
      ),
      socialSection: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton(
            key: const Key('forgotPasswordBackToSignInButton'),
            onPressed: () => context.go(AppRoutes.signInPath),
            child: Text(l10n.authForgotPasswordBackAction, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      legalText: AuthLegalText(
        leadingText: l10n.authForgotPasswordLegalLeading,
      ),
    );
  }

  _RecoveryBannerData _buildBannerData({
    required AppLocalizations l10n,
    required ColorScheme colorScheme,
    required AuthState state,
    required String? validationMessage,
  }) {
    if (validationMessage != null) {
      return _RecoveryBannerData(
        key: const Key('forgotPasswordFeedbackBanner'),
        message: validationMessage,
        icon: Icons.error_outline,
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
      );
    }

    if (!_didResetRecoveryState) {
      return _RecoveryBannerData(
        message: l10n.authForgotPasswordDefaultBanner,
        icon: Icons.info_outline,
        backgroundColor: colorScheme.tertiaryContainer,
        foregroundColor: colorScheme.onTertiaryContainer,
      );
    }

    return switch (state.passwordRecoveryStatus) {
      PasswordRecoveryStatus.success => _RecoveryBannerData(
          key: const Key('forgotPasswordFeedbackBanner'),
          message: l10n.authForgotPasswordSuccess,
          icon: Icons.check_circle_outline,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
      PasswordRecoveryStatus.failure => _RecoveryBannerData(
          key: const Key('forgotPasswordFeedbackBanner'),
          message: state.passwordRecoveryFailure?.localized(l10n) ??
              l10n.authErrorGenericFailure,
          icon: Icons.error_outline,
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
        ),
      _ => _RecoveryBannerData(
          message: l10n.authForgotPasswordDefaultBanner,
          icon: Icons.info_outline,
          backgroundColor: colorScheme.tertiaryContainer,
          foregroundColor: colorScheme.onTertiaryContainer,
        ),
    };
  }
}

class _RecoveryBannerData {
  const _RecoveryBannerData({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.key,
  });

  final Key? key;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
}