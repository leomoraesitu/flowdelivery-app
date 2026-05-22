import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';

enum AuthPageTab { signIn, signUp, reports }

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.activeTab,
    required this.onTapSignIn,
    required this.onTapSignUp,
    required this.form,
    required this.primaryAction,
    required this.socialSection,
    required this.legalText,
    this.signInButtonKey,
    this.signUpButtonKey,
    this.statusBanner,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final AuthPageTab activeTab;
  final VoidCallback onTapSignIn;
  final VoidCallback onTapSignUp;
  final Widget form;
  final Widget primaryAction;
  final Widget socialSection;
  final Widget legalText;
  final Key? signInButtonKey;
  final Key? signUpButtonKey;
  final Widget? statusBanner;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: colorScheme.onPrimary, size: 36),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                title,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _AuthTabBar(
                activeTab: activeTab,
                onTapSignIn: onTapSignIn,
                onTapSignUp: onTapSignUp,
                signInButtonKey: signInButtonKey,
                signUpButtonKey: signUpButtonKey,
              ),
              const SizedBox(height: AppSpacing.xl),
              form,
              const SizedBox(height: AppSpacing.xl),
              primaryAction,
              if (statusBanner != null) ...[
                const SizedBox(height: AppSpacing.md),
                statusBanner!,
              ],
              const SizedBox(height: AppSpacing.lg),
              socialSection,
              const SizedBox(height: AppSpacing.xxl),
              legalText,
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthStatusBanner extends StatelessWidget {
  const AuthStatusBanner({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    super.key,
  });

  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.18)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foregroundColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthSocialSection extends StatelessWidget {
  const AuthSocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(l10n.authSocialDivider, style: textTheme.titleMedium),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: Text(l10n.authSocialGoogle),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.apple),
                label: Text(l10n.authSocialApple),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.authSocialComingSoon,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class AuthLegalText extends StatelessWidget {
  const AuthLegalText({required this.leadingText, super.key});

  final String leadingText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Text.rich(
        TextSpan(
          text: leadingText,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          children: [
            TextSpan(
              text: l10n.authLegalTerms,
              style: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _AuthTabBar extends StatelessWidget {
  const _AuthTabBar({
    required this.activeTab,
    required this.onTapSignIn,
    required this.onTapSignUp,
    this.signInButtonKey,
    this.signUpButtonKey,
  });

  final AuthPageTab activeTab;
  final VoidCallback onTapSignIn;
  final VoidCallback onTapSignUp;
  final Key? signInButtonKey;
  final Key? signUpButtonKey;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: _AuthTabButton(
                buttonKey: signInButtonKey,
                label: l10n.authTabSignIn,
                selected: activeTab == AuthPageTab.signIn,
                onPressed: onTapSignIn,
              ),
            ),
            Expanded(
              child: _AuthTabButton(
                buttonKey: signUpButtonKey,
                label: l10n.authTabSignUp,
                selected: activeTab == AuthPageTab.signUp,
                onPressed: onTapSignUp,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  l10n.authTabReports,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTabButton extends StatelessWidget {
  const _AuthTabButton({
    this.buttonKey,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final Key? buttonKey;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (selected) {
      return Container(
        key: buttonKey,
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: colorScheme.onTertiaryContainer,
          ),
        ),
      );
    }

    return TextButton(key: buttonKey, onPressed: onPressed, child: Text(label));
  }
}
