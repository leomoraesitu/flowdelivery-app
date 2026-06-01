import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authViewModel = ref.read(authViewModelProvider);

  return GoRouter(
    initialLocation: AppRoutes.rootPath,
    refreshListenable: authViewModel,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.rootPath,
        name: AppRoutes.rootName,
        redirect: (context, state) => AppRoutes.homePath,
      ),
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.homeName,
        builder: (context, state) => const _HomePlaceholderPage(),
      ),
      GoRoute(
        path: AppRoutes.signInPath,
        name: AppRoutes.signInName,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: AppRoutes.signUpPath,
        name: AppRoutes.signUpName,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordPath,
        name: AppRoutes.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetPasswordPath,
        name: AppRoutes.resetPasswordName,
        builder: (context, state) => const ResetPasswordPage(),
      ),
    ],
    redirect: (context, state) {
      final authStatus = authViewModel.state.status;
      final currentPath = state.uri.path;
      final isInAuthRoute =
          currentPath == AppRoutes.signInPath ||
          currentPath == AppRoutes.signUpPath ||
          currentPath == AppRoutes.forgotPasswordPath ||
          currentPath == AppRoutes.resetPasswordPath;
      final isProtectedRoute = currentPath == AppRoutes.homePath;

      if (authStatus == AuthStatus.loading) {
        return null;
      }

      if (authStatus == AuthStatus.authenticated &&
          isInAuthRoute &&
          currentPath != AppRoutes.resetPasswordPath) {
        return AppRoutes.homePath;
      }

      if (authStatus != AuthStatus.authenticated && isProtectedRoute) {
        return AppRoutes.signInPath;
      }

      return null;
    },
  );
});

class _HomePlaceholderPage extends StatelessWidget {
  const _HomePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(body: Center(child: Text(l10n.appHomePlaceholder)));
  }
}
