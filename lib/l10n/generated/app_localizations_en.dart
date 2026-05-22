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
      'This first version adds the recovery entry point while the complete flow still awaits approval.';

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
      'When the real recovery flow is approved, this page will call the authentication layer instead of acting only as a visual placeholder.';

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
}
