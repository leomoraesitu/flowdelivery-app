import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _authPageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

class FakeAuthRepository implements AuthRepository {
  String? lastSignInEmail;
  String? lastSignUpEmail;

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    lastSignInEmail = email;
    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    lastSignUpEmail = email;
    return AuthUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  group('Auth pages', () {
    testWidgets('sign in page renders fields, action and navigation link', (
      tester,
    ) async {
      final fakeRepository = FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
          child: MaterialApp(
            theme: _authPageTestTheme,
            home: const SignInPage(),
          ),
        ),
      );

      expect(find.byKey(const Key('signInEmailField')), findsOneWidget);
      expect(find.byKey(const Key('signInPasswordField')), findsOneWidget);
      expect(find.byKey(const Key('signInPrimaryButton')), findsOneWidget);
      expect(
        find.byKey(const Key('signInNavigateToSignUpButton')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('signInEmailField')),
        'user@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('signInPasswordField')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('signInPrimaryButton')));
      await tester.pump();

      expect(fakeRepository.lastSignInEmail, 'user@example.com');
    });

    testWidgets('sign up page renders fields, action and navigation link', (
      tester,
    ) async {
      final fakeRepository = FakeAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
          child: MaterialApp(
            theme: _authPageTestTheme,
            home: const SignUpPage(),
          ),
        ),
      );

      expect(find.byKey(const Key('signUpEmailField')), findsOneWidget);
      expect(find.byKey(const Key('signUpPasswordField')), findsOneWidget);
      expect(find.byKey(const Key('signUpPrimaryButton')), findsOneWidget);
      expect(
        find.byKey(const Key('signUpNavigateToSignInButton')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('signUpEmailField')),
        'new@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('signUpPasswordField')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('signUpPrimaryButton')));
      await tester.pump();

      expect(fakeRepository.lastSignUpEmail, 'new@example.com');
    });
  });
}
