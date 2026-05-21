import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authViewModel = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: AppRoutes.homePath,
    refreshListenable: authViewModel,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.homePath,
        name: AppRoutes.homeName,
        builder: (context, state) => const _HomePlaceholderPage(),
      ),
      GoRoute(
        path: AppRoutes.signInPath,
        name: AppRoutes.signInName,
        builder: (context, state) => const _SignInPlaceholderPage(),
      ),
      GoRoute(
        path: AppRoutes.signUpPath,
        name: AppRoutes.signUpName,
        builder: (context, state) => const _SignUpPlaceholderPage(),
      ),
    ],
    redirect: (context, state) {
      final authStatus = authViewModel.state.status;
      final currentPath = state.uri.path;
      final isInAuthRoute = currentPath == AppRoutes.signInPath ||
          currentPath == AppRoutes.signUpPath;

      if (authStatus == AuthStatus.loading) {
        return null;
      }

      if (authStatus == AuthStatus.authenticated && isInAuthRoute) {
        return AppRoutes.homePath;
      }

      if (authStatus != AuthStatus.authenticated && !isInAuthRoute) {
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
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}

class _SignInPlaceholderPage extends StatelessWidget {
  const _SignInPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sign In'),
      ),
    );
  }
}

class _SignUpPlaceholderPage extends StatelessWidget {
  const _SignUpPlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Sign Up'),
      ),
    );
  }
}
