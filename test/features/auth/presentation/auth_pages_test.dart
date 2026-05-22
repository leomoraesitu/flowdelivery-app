import 'package:flowdelivery_app/app/theme/app_theme.dart';
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';

final _authPageTestTheme = AppTheme.light.copyWith(
  splashFactory: NoSplash.splashFactory,
);

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.failRecovery = false});

  final bool failRecovery;

  String? lastSignInEmail;
  String? lastSignUpEmail;
  String? lastRecoveryEmail;

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

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    if (failRecovery) {
      throw const AuthFailure(
        code: AuthFailureCode.genericFailure,
        fallbackMessage: 'Nao foi possivel enviar o e-mail de recuperacao',
      );
    }

    lastRecoveryEmail = email;
  }
}

Widget _buildTestApp({required Widget home, required FakeAuthRepository fakeRepository}) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
    child: MaterialApp(
      theme: _authPageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

Widget _buildTestAppWithContainer({
  required Widget home,
  required ProviderContainer container,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: _authPageTestTheme,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

void main() {
  group('Auth pages', () {
    testWidgets('sign in page renders fields, action and navigation link', (
      tester,
    ) async {
      final fakeRepository = FakeAuthRepository();

      await tester.pumpWidget(_buildTestApp(home: const SignInPage(), fakeRepository: fakeRepository));

      expect(find.byKey(const Key('signInEmailField')), findsOneWidget);
      expect(find.byKey(const Key('signInPasswordField')), findsOneWidget);
      expect(find.byKey(const Key('signInPrimaryButton')), findsOneWidget);
      expect(
        find.byKey(const Key('signInNavigateToSignUpButton')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('signInForgotPasswordButton')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('signInEmailField')),
        'user@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('signInPasswordField')),
        'password123',
      );
      await tester.ensureVisible(find.byKey(const Key('signInPrimaryButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('signInPrimaryButton')));
      await tester.pump();

      expect(fakeRepository.lastSignInEmail, 'user@example.com');
    });

    testWidgets('sign up page renders fields, action and navigation link', (
      tester,
    ) async {
      final fakeRepository = FakeAuthRepository();

      await tester.pumpWidget(_buildTestApp(home: const SignUpPage(), fakeRepository: fakeRepository));

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
      await tester.ensureVisible(find.byKey(const Key('signUpPrimaryButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('signUpPrimaryButton')));
      await tester.pump();

      expect(fakeRepository.lastSignUpEmail, 'new@example.com');
    });

    testWidgets('forgot password page submits recovery request', (tester) async {
      final fakeRepository = FakeAuthRepository();

      await tester.pumpWidget(_buildTestApp(home: const ForgotPasswordPage(), fakeRepository: fakeRepository));

      await tester.enterText(
        find.byKey(const Key('forgotPasswordEmailField')),
        'recover@example.com',
      );

      await tester.ensureVisible(find.byKey(const Key('forgotPasswordPrimaryButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('forgotPasswordPrimaryButton')));
      await tester.pumpAndSettle();

      expect(fakeRepository.lastRecoveryEmail, 'recover@example.com');
      expect(find.byKey(const Key('forgotPasswordFeedbackBanner')), findsOneWidget);
      expect(find.textContaining('Link de recuperacao solicitado'), findsOneWidget);
    });

    testWidgets('forgot password page renders failure banner', (tester) async {
      final fakeRepository = FakeAuthRepository(failRecovery: true);

      await tester.pumpWidget(_buildTestApp(home: const ForgotPasswordPage(), fakeRepository: fakeRepository));

      await tester.enterText(
        find.byKey(const Key('forgotPasswordEmailField')),
        'recover@example.com',
      );

      await tester.ensureVisible(find.byKey(const Key('forgotPasswordPrimaryButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('forgotPasswordPrimaryButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('forgotPasswordFeedbackBanner')), findsOneWidget);
      expect(
        find.text('Nao foi possivel enviar o e-mail de recuperacao'),
        findsOneWidget,
      );
    });

    testWidgets('forgot password page validates empty email before submit', (
      tester,
    ) async {
      final fakeRepository = FakeAuthRepository();

      await tester.pumpWidget(
        _buildTestApp(
          home: const ForgotPasswordPage(),
          fakeRepository: fakeRepository,
        ),
      );

      await tester.ensureVisible(
        find.byKey(const Key('forgotPasswordPrimaryButton')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('forgotPasswordPrimaryButton')));
      await tester.pumpAndSettle();

      expect(fakeRepository.lastRecoveryEmail, isNull);
      expect(find.byKey(const Key('forgotPasswordFeedbackBanner')), findsOneWidget);
    });

    testWidgets('forgot password page resets stale feedback when revisited', (
      tester,
    ) async {
      final fakeRepository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _buildTestAppWithContainer(
          home: const ForgotPasswordPage(),
          container: container,
        ),
      );

      await tester.enterText(
        find.byKey(const Key('forgotPasswordEmailField')),
        'recover@example.com',
      );
      await tester.ensureVisible(
        find.byKey(const Key('forgotPasswordPrimaryButton')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('forgotPasswordPrimaryButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('forgotPasswordFeedbackBanner')), findsOneWidget);
      expect(find.textContaining('Link de recuperacao solicitado'), findsOneWidget);

      await tester.pumpWidget(
        _buildTestAppWithContainer(
          home: const SizedBox.shrink(),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _buildTestAppWithContainer(
          home: const ForgotPasswordPage(),
          container: container,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('forgotPasswordFeedbackBanner')), findsNothing);
      expect(find.textContaining('Link de recuperacao solicitado'), findsNothing);
    });
  });
}
