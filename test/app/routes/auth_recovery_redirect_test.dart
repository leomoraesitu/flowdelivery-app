import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/app/routes/auth_recovery_redirect.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds reset-password redirect from the current origin', () {
    final redirect = buildPasswordRecoveryRedirectUrl(
      currentUri: Uri.parse('http://localhost:3000/#/forgot-password'),
    );

    expect(redirect, 'http://localhost:3000${AppRoutes.resetPasswordPath}');
  });

  test('drops query and fragment data from recovery redirect', () {
    final redirect = buildPasswordRecoveryRedirectUrl(
      currentUri: Uri.parse(
        'http://127.0.0.1:3000/sign-in?tab=auth#access_token=secret',
      ),
    );

    expect(redirect, 'http://127.0.0.1:3000${AppRoutes.resetPasswordPath}');
  });

  test('prefers configured origin when available', () {
    final redirect = buildPasswordRecoveryRedirectUrl(
      currentUri: Uri.parse('http://localhost:3000/#/forgot-password'),
      configuredOrigin: 'https://qa.flowdelivery.app',
    );

    expect(redirect, 'https://qa.flowdelivery.app${AppRoutes.resetPasswordPath}');
  });

  test('falls back to current origin when configured origin is invalid', () {
    final redirect = buildPasswordRecoveryRedirectUrl(
      currentUri: Uri.parse('http://localhost:3000/#/forgot-password'),
      configuredOrigin: 'not-a-valid-origin',
    );

    expect(redirect, 'http://localhost:3000${AppRoutes.resetPasswordPath}');
  });

  test('preserves the configured-origin base path (GitHub Pages subpath)', () {
    final redirect = buildPasswordRecoveryRedirectUrl(
      currentUri: Uri.parse('https://leomoraesitu.github.io/flowdelivery-app/'),
      configuredOrigin: 'https://leomoraesitu.github.io/flowdelivery-app',
    );

    expect(
      redirect,
      'https://leomoraesitu.github.io/flowdelivery-app'
      '${AppRoutes.resetPasswordPath}',
    );
  });

  test('normalizes a trailing slash in the configured base path', () {
    final redirect = buildPasswordRecoveryRedirectUrl(
      currentUri: Uri.parse('https://leomoraesitu.github.io/flowdelivery-app/'),
      configuredOrigin: 'https://leomoraesitu.github.io/flowdelivery-app/',
    );

    expect(
      redirect,
      'https://leomoraesitu.github.io/flowdelivery-app'
      '${AppRoutes.resetPasswordPath}',
    );
  });
}
