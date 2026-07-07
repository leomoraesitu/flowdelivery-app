// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authErrorInvalidCredentials => 'Invalid email or password.';

  @override
  String get authErrorEmailNotConfirmed =>
      'Confirm your email before signing in.';

  @override
  String get authErrorUserAlreadyRegistered =>
      'This email is already registered.';

  @override
  String get authErrorPasswordTooShort =>
      'Password must be at least 6 characters long.';

  @override
  String get authErrorNetworkFailure =>
      'Connection failed. Check your internet and try again.';

  @override
  String get authErrorGenericFailure =>
      'Could not complete authentication. Try again.';

  @override
  String get authErrorUnconfiguredEnvironment =>
      'Supabase is not configured. Define SUPABASE_URL and SUPABASE_ANON_KEY to enable authentication.';

  @override
  String get authSignInTitle => 'Welcome to FlowDelivery';

  @override
  String get authSignInSubtitle =>
      'Delicious dishes from your favorite local restaurants, delivered to your door.';

  @override
  String get authSignUpTitle => 'Create your FlowDelivery account';

  @override
  String get authSignUpSubtitle =>
      'Save your favorite restaurants, track orders, and check out faster.';

  @override
  String get authForgotPasswordTitle => 'Recover your password';

  @override
  String get authForgotPasswordSubtitle =>
      'Request a recovery link to reset your password for the provided email.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authEmailHint => 'name@example.com';

  @override
  String get authSignInPasswordHint => 'Enter your password';

  @override
  String get authSignUpPasswordHint => 'Create a secure password';

  @override
  String get authForgotPasswordCta => 'Forgot your password?';

  @override
  String get authSignInPrimaryAction => 'Sign in';

  @override
  String get authSignUpPrimaryAction => 'Create account';

  @override
  String get authForgotPasswordPrimaryAction => 'Request recovery link';

  @override
  String get authForgotPasswordBackAction => 'Back to sign in';

  @override
  String get authSignInSuccess =>
      'Signed in successfully. Redirecting to your next destination.';

  @override
  String get authSignUpSuccess =>
      'Account created successfully. Redirecting to your next destination.';

  @override
  String get authForgotPasswordHelper =>
      'We\'ll send a recovery link to this email when it is available in your environment.';

  @override
  String get authForgotPasswordPlaceholderInfo =>
      'If your environment is configured correctly, we will send the recovery link to the provided email.';

  @override
  String get authForgotPasswordEmptyEmailError =>
      'Enter your email to request the recovery link.';

  @override
  String get authForgotPasswordSuccess =>
      'Recovery link requested. Check your inbox for the next steps.';

  @override
  String get authForgotPasswordDefaultBanner =>
      'Password recovery is connected to the authentication layer. Use a valid configured environment to send the email.';

  @override
  String get authResetPasswordTitle => 'Create a new password';

  @override
  String get authResetPasswordSubtitle =>
      'Set a new password after opening the recovery link sent to your email.';

  @override
  String get authResetPasswordConfirmLabel => 'Confirm password';

  @override
  String get authResetPasswordPasswordHint => 'Enter the new password';

  @override
  String get authResetPasswordConfirmHint => 'Repeat the new password';

  @override
  String get authResetPasswordPrimaryAction => 'Update password';

  @override
  String get authResetPasswordEmptyPasswordError =>
      'Enter the new password to continue.';

  @override
  String get authResetPasswordMismatchError => 'The passwords do not match.';

  @override
  String get authResetPasswordSuccess =>
      'Password updated successfully. Go back to sign in with the new password.';

  @override
  String get authResetPasswordBackAction => 'Back to sign in';

  @override
  String get authSignInLegalLeading => 'By continuing, you agree to our ';

  @override
  String get authSignUpLegalLeading =>
      'By creating an account, you agree to our ';

  @override
  String get authForgotPasswordLegalLeading => 'Need immediate help? See our ';

  @override
  String get authLegalTerms => 'Terms of Service';

  @override
  String get authSocialDivider => 'or continue with';

  @override
  String get authSocialGoogle => 'Google';

  @override
  String get authSocialApple => 'Apple';

  @override
  String get authSocialComingSoon => 'Social sign-in coming soon.';

  @override
  String get appHomePlaceholder => 'Home';

  @override
  String get authTabSignIn => 'Sign in';

  @override
  String get authTabSignUp => 'Create account';

  @override
  String get authTabReports => 'Reports';

  @override
  String get homeDeliveryAddressLabel => 'Deliver to';

  @override
  String homeDeliveryAddressValue(String address) {
    return '$address';
  }

  @override
  String get homeSearchHint => 'Search for dishes or restaurants';

  @override
  String get homeCategoryAll => 'All';

  @override
  String get homeCategoryBurgers => 'Burgers';

  @override
  String get homeCategoryPizza => 'Pizza';

  @override
  String get homeCategorySushi => 'Sushi';

  @override
  String get homeCategoryHealthy => 'Healthy';

  @override
  String get homeBannerTitle => 'Deals for your next order';

  @override
  String homeBannerDiscountValue(int discountPercentage) {
    return '$discountPercentage% OFF';
  }

  @override
  String get homeBannerFreeDeliveryBadge => 'Free delivery';

  @override
  String get homeFeaturedSectionTitle => 'Featured restaurants';

  @override
  String get homeSeeAllAction => 'See all';

  @override
  String homeRestaurantRatingAndDelivery(
    double rating,
    int minMinutes,
    int maxMinutes,
  ) {
    return '$rating • $minMinutes-$maxMinutes min';
  }

  @override
  String get homeLoadingStateTitle => 'Loading your home feed';

  @override
  String get homeLoadingStateMessage =>
      'We are fetching the latest restaurants and deals for you.';

  @override
  String get homeLoadingStateSemanticLabel => 'Loading home feed';

  @override
  String get homeErrorStateTitle => 'Could not load your home feed';

  @override
  String get homeErrorStateMessage =>
      'Try again to refresh restaurants and deals.';

  @override
  String get homeRetryAction => 'Try again';

  @override
  String get homeEmptyStateTitle => 'Nothing featured right now';

  @override
  String get homeEmptyStateMessage =>
      'Check back in a moment for new restaurants and offers.';

  @override
  String get homeDiscoveryEmptyStateTitle => 'No restaurants found';

  @override
  String get homeDiscoveryEmptyStateMessage =>
      'Try adjusting your search or clearing the filters to see more options.';

  @override
  String get homeDiscoveryClearFiltersAction => 'Clear filters';

  @override
  String get restaurantDetailsBackAction => 'Back';

  @override
  String get restaurantDetailsLoadingStateTitle => 'Loading restaurant';

  @override
  String get restaurantDetailsLoadingStateMessage =>
      'We are fetching the latest menu and restaurant details for you.';

  @override
  String get restaurantDetailsLoadingStateSemanticLabel =>
      'Loading restaurant details and menu';

  @override
  String get restaurantDetailsErrorStateTitle =>
      'Could not load the restaurant';

  @override
  String get restaurantDetailsErrorStateMessage =>
      'Try again to refresh the restaurant details and menu.';

  @override
  String get restaurantDetailsRetryAction => 'Try again';

  @override
  String get restaurantDetailsEmptyStateTitle => 'Menu unavailable right now';

  @override
  String get restaurantDetailsEmptyStateMessage =>
      'Check back in a moment for this restaurant\'s options.';

  @override
  String get restaurantDetailsMenuSectionTitle => 'Menu';

  @override
  String get restaurantDetailsCategoryPopular => 'Popular';

  @override
  String get restaurantDetailsCategoryBurgers => 'Burgers';

  @override
  String get restaurantDetailsCategorySides => 'Sides';

  @override
  String get restaurantDetailsCategoryDrinks => 'Drinks';

  @override
  String get restaurantDetailsCategorySalads => 'Salads';

  @override
  String get restaurantDetailsCategoryPastas => 'Pasta';

  @override
  String get restaurantDetailsCategoryRolls => 'Rolls';

  @override
  String get restaurantDetailsCategoryBowls => 'Bowls';

  @override
  String get restaurantDetailsCategoryTacos => 'Tacos';

  @override
  String restaurantDetailsRatingAndDelivery(
    double rating,
    int minMinutes,
    int maxMinutes,
  ) {
    return '$rating • $minMinutes-$maxMinutes min';
  }

  @override
  String restaurantDetailsMenuSemanticLabel(String restaurantName) {
    return '$restaurantName menu';
  }

  @override
  String restaurantDetailsCategoryFilterSemanticLabel(String categoryName) {
    return 'Filter menu by $categoryName';
  }

  @override
  String get homeBottomNavHome => 'Home';

  @override
  String get homeBottomNavBrowse => 'Browse';

  @override
  String get homeBottomNavOrders => 'Orders';

  @override
  String get homeBottomNavAccount => 'Account';

  @override
  String get productDetailsBackAction => 'Back';

  @override
  String get productDetailsLoadingStateTitle => 'Loading product';

  @override
  String get productDetailsLoadingStateMessage =>
      'We are fetching the latest details for this product.';

  @override
  String get productDetailsLoadingStateSemanticLabel =>
      'Loading product details';

  @override
  String get productDetailsErrorStateTitle => 'Could not load the product';

  @override
  String get productDetailsErrorStateMessage =>
      'Try again to refresh the product details.';

  @override
  String get productDetailsRetryAction => 'Try again';

  @override
  String get productDetailsNotFoundStateTitle => 'Product unavailable';

  @override
  String get productDetailsNotFoundStateMessage =>
      'This product is not available at this restaurant.';

  @override
  String productDetailsImageSemanticLabel(String productName) {
    return '$productName image';
  }

  @override
  String productDetailsPriceSemanticLabel(String price) {
    return 'Price $price';
  }

  @override
  String get cartTitle => 'My Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyMessage =>
      'Add items from a restaurant to start your order.';

  @override
  String get cartEmptyAction => 'Explore restaurants';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartClearAction => 'Clear cart';

  @override
  String get cartRemoveItem => 'Remove item';

  @override
  String get cartIncreaseQuantity => 'Increase quantity';

  @override
  String get cartDecreaseQuantity => 'Decrease quantity';

  @override
  String get cartProceedToCheckout => 'Proceed to Checkout';

  @override
  String get cartAddToCart => 'Add to cart';

  @override
  String get cartUpdateQuantity => 'Update quantity';

  @override
  String get cartAlreadyInCart => 'In cart';

  @override
  String get cartDifferentRestaurantTitle => 'Start a new order?';

  @override
  String get cartDifferentRestaurantMessage =>
      'Your cart has items from another restaurant. Clear it and add this item?';

  @override
  String get cartDifferentRestaurantConfirm => 'Yes, clear';

  @override
  String get cartDifferentRestaurantCancel => 'Cancel';

  @override
  String cartItemImageSemanticLabel(String name) {
    return '$name image';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutDeliveryAddressTitle => 'Delivery address';

  @override
  String get checkoutDemoAddress => 'Rua das Flores, 123 - Centro';

  @override
  String get checkoutPaymentTitle => 'Payment method';

  @override
  String get checkoutPaymentCashOnDelivery => 'Pay on delivery';

  @override
  String get checkoutPaymentMethodCashOnDeliveryDescription =>
      'Pay when your order arrives.';

  @override
  String get checkoutPaymentStatusTitle => 'Payment status';

  @override
  String get checkoutPaymentStatusPendingOnDelivery =>
      'Pending payment on delivery';

  @override
  String get checkoutSummaryTitle => 'Order summary';

  @override
  String get checkoutSubtotal => 'Subtotal';

  @override
  String get checkoutDeliveryFee => 'Delivery fee';

  @override
  String get checkoutTotal => 'Total';

  @override
  String checkoutItemQuantity(int quantity) {
    return '${quantity}x';
  }

  @override
  String get checkoutConfirmAction => 'Confirm order';

  @override
  String get checkoutSubmitting => 'Placing your order...';

  @override
  String get checkoutErrorTitle => 'We could not place your order';

  @override
  String get checkoutErrorMessage =>
      'Something went wrong while placing your order. Please try again.';

  @override
  String get checkoutRetryAction => 'Try again';

  @override
  String get checkoutSuccessTitle => 'Order confirmed!';

  @override
  String checkoutSuccessMessage(String orderId) {
    return 'Your order $orderId has been received and is being prepared.';
  }

  @override
  String checkoutSuccessPaymentStatus(String paymentStatus) {
    return 'Payment status: $paymentStatus';
  }

  @override
  String get checkoutSuccessBackToHome => 'Back to Home';
}
