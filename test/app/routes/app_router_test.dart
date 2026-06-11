import 'dart:async';

import 'package:flowdelivery_app/app/routes/app_router.dart';
import 'package:flowdelivery_app/app/routes/app_routes.dart';
import 'package:flowdelivery_app/features/auth/domain/entities/auth_user.dart';
import 'package:flowdelivery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:flowdelivery_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flowdelivery_app/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:flowdelivery_app/features/home/presentation/pages/home_page.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:flowdelivery_app/features/product_details/presentation/pages/product_details_page.dart';
import 'package:flowdelivery_app/features/product_details/presentation/providers/product_details_providers.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_details.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/repositories/restaurant_details_repository.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/pages/restaurant_details_page.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/providers/restaurant_details_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.pendingSignIn});

  final Completer<AuthUser>? pendingSignIn;

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (pendingSignIn case final completer?) {
      return completer.future;
    }

    return AuthUser(id: 'user-1', email: email);
  }

  @override
  Future<AuthUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return AuthUser(id: 'user-2', email: email);
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> sendPasswordRecoveryEmail({required String email}) async {}

  @override
  Future<void> updatePassword({required String password}) async {}
}

class _FakeRestaurantDetailsRepository implements RestaurantDetailsRepository {
  @override
  Future<RestaurantDetails> getRestaurantDetails(String restaurantId) async {
    return RestaurantDetails(
      id: restaurantId,
      name: 'Burgers & Co',
      imageAssetPath: 'assets/images/restaurants/burgers_and_co.png',
      rating: 4.8,
      deliveryTimeMinMinutes: 20,
      deliveryTimeMaxMinutes: 35,
      cuisine: 'Burgers',
      categories: const [
        RestaurantMenuCategory(id: 'popular'),
        RestaurantMenuCategory(id: 'sides'),
      ],
      items: const [
        RestaurantMenuItem(
          id: 'burger-1',
          categoryId: 'popular',
          name: 'Classic Burger',
          description: 'Beef, cheese, and house sauce.',
          imageAssetPath: 'assets/images/menu/classic_burger.png',
          priceInCents: 2890,
        ),
      ],
    );
  }
}

class _FakeProductDetailsRepository implements ProductDetailsRepository {
  @override
  Future<ProductDetails?> getProductDetails(String productId) async {
    return ProductDetails(
      id: productId,
      restaurantId: 'restaurant-123',
      categoryId: 'popular',
      name: 'Classic Burger',
      description: 'Beef, cheese, and house sauce.',
      imageAssetPath: 'assets/images/menu/classic_burger.png',
      priceInCents: 2890,
    );
  }
}

void main() {
  testWidgets('redirects unauthenticated users to sign-in route', (
    tester,
  ) async {
    late GoRouter router;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsOneWidget);
    expect(router.state.uri.path, AppRoutes.signInPath);

    router.go(AppRoutes.forgotPasswordPath);
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
  });

  testWidgets(
    'redirects unauthenticated users away from restaurant details route',
    (tester) async {
      late GoRouter router;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
            restaurantDetailsRepositoryProvider.overrideWithValue(
              _FakeRestaurantDetailsRepository(),
            ),
          ],
          child: Consumer(
            builder: (context, ref, child) {
              router = ref.watch(appRouterProvider);
              return MaterialApp.router(
                routerConfig: router,
                locale: const Locale('pt', 'BR'),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          ),
        ),
      );

      router.goNamed(
        AppRoutes.restaurantDetailsName,
        pathParameters: {'restaurantId': 'restaurant-123'},
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.signInPath);
      expect(find.byType(SignInPage), findsOneWidget);
    },
  );

  testWidgets('allows unauthenticated users to reach reset-password route', (
    tester,
  ) async {
    late GoRouter router;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    router.go(AppRoutes.resetPasswordPath);
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.resetPasswordPath);
    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });

  testWidgets('redirects unauthenticated users away from home route', (
    tester,
  ) async {
    late GoRouter router;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    router.go(AppRoutes.homePath);
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.signInPath);
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('allows authenticated users to open restaurant details route', (
    tester,
  ) async {
    late GoRouter router;
    final fakeRepository = _FakeAuthRepository();
    final authViewModel = AuthViewModel(authRepository: fakeRepository);

    await authViewModel.signInWithEmailAndPassword(
      email: 'user@example.com',
      password: 'password123',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          authViewModelProvider.overrideWith((ref) => authViewModel),
          restaurantDetailsRepositoryProvider.overrideWithValue(
            _FakeRestaurantDetailsRepository(),
          ),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    router.goNamed(
      AppRoutes.restaurantDetailsName,
      pathParameters: {'restaurantId': 'restaurant-123'},
    );
    await tester.pumpAndSettle();

    expect(router.state.uri.path, '/restaurants/restaurant-123');
    expect(find.byType(RestaurantDetailsPage), findsOneWidget);
  });

  testWidgets('allows authenticated users to open product details route', (
    tester,
  ) async {
    late GoRouter router;
    final fakeRepository = _FakeAuthRepository();
    final authViewModel = AuthViewModel(authRepository: fakeRepository);

    await authViewModel.signInWithEmailAndPassword(
      email: 'user@example.com',
      password: 'password123',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          authViewModelProvider.overrideWith((ref) => authViewModel),
          productDetailsRepositoryProvider.overrideWithValue(
            _FakeProductDetailsRepository(),
          ),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    router.goNamed(
      AppRoutes.productDetailsName,
      pathParameters: {
        'restaurantId': 'restaurant-123',
        'productId': 'burger-1',
      },
    );
    await tester.pumpAndSettle();

    expect(
      router.state.uri.path,
      '/restaurants/restaurant-123/products/burger-1',
    );
    expect(find.byType(ProductDetailsPage), findsOneWidget);
  });

  testWidgets(
    'redirects unauthenticated users away from product details route',
    (tester) async {
      late GoRouter router;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
          ],
          child: Consumer(
            builder: (context, ref, child) {
              router = ref.watch(appRouterProvider);
              return MaterialApp.router(
                routerConfig: router,
                locale: const Locale('pt', 'BR'),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          ),
        ),
      );

      router.goNamed(
        AppRoutes.productDetailsName,
        pathParameters: {
          'restaurantId': 'restaurant-123',
          'productId': 'burger-1',
        },
      );
      await tester.pumpAndSettle();

      expect(router.state.uri.path, AppRoutes.signInPath);
      expect(find.byType(SignInPage), findsOneWidget);
    },
  );

  testWidgets('keeps authenticated recovery sessions on reset-password route', (
    tester,
  ) async {
    late GoRouter router;
    final fakeRepository = _FakeAuthRepository();
    final authViewModel = AuthViewModel(authRepository: fakeRepository);

    await authViewModel.signInWithEmailAndPassword(
      email: 'recover@example.com',
      password: 'password123',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          authViewModelProvider.overrideWith((ref) => authViewModel),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    router.go(AppRoutes.resetPasswordPath);
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.resetPasswordPath);
    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });

  testWidgets('redirects authenticated users away from auth routes', (
    tester,
  ) async {
    late GoRouter router;
    final fakeRepository = _FakeAuthRepository();
    final authViewModel = AuthViewModel(authRepository: fakeRepository);

    await authViewModel.signInWithEmailAndPassword(
      email: 'user@example.com',
      password: 'password123',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          authViewModelProvider.overrideWith((ref) => authViewModel),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);

    router.go(AppRoutes.signUpPath);
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.homePath);
  });

  testWidgets('redirects authenticated users from root entry to home route', (
    tester,
  ) async {
    late GoRouter router;
    final fakeRepository = _FakeAuthRepository();
    final authViewModel = AuthViewModel(authRepository: fakeRepository);

    await authViewModel.signInWithEmailAndPassword(
      email: 'user@example.com',
      password: 'password123',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          authViewModelProvider.overrideWith((ref) => authViewModel),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.homePath);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('keeps current route while auth state is loading', (
    tester,
  ) async {
    late GoRouter router;
    final pendingSignIn = Completer<AuthUser>();
    final fakeRepository = _FakeAuthRepository(pendingSignIn: pendingSignIn);
    final authViewModel = AuthViewModel(authRepository: fakeRepository);

    unawaited(
      authViewModel.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'password123',
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          authViewModelProvider.overrideWith((ref) => authViewModel),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            router = ref.watch(appRouterProvider);
            return MaterialApp.router(
              routerConfig: router,
              locale: const Locale('pt', 'BR'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pump();

    expect(router.state.uri.path, AppRoutes.homePath);
  });
}
