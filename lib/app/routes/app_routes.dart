abstract final class AppRoutes {
  static const String rootName = 'root';
  static const String homeName = 'home';
  static const String restaurantDetailsName = 'restaurant-details';
  static const String productDetailsName = 'product-details';
  static const String signInName = 'sign-in';
  static const String signUpName = 'sign-up';
  static const String forgotPasswordName = 'forgot-password';
  static const String resetPasswordName = 'reset-password';

  static const String rootPath = '/';
  static const String homePath = '/home';
  static const String restaurantDetailsBasePath = '/restaurants';
  static const String restaurantDetailsPath = '/restaurants/:restaurantId';
  static const String productDetailsPath =
      '/restaurants/:restaurantId/products/:productId';
  static const String signInPath = '/sign-in';
  static const String signUpPath = '/sign-up';
  static const String forgotPasswordPath = '/forgot-password';
  static const String resetPasswordPath = '/reset-password';
}
