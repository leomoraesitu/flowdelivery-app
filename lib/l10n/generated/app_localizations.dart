import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// Shown when the user enters invalid sign in credentials.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail ou senha invalidos.'**
  String get authErrorInvalidCredentials;

  /// Shown when the user tries to sign in without confirming the email address.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirme seu e-mail antes de entrar.'**
  String get authErrorEmailNotConfirmed;

  /// Shown when sign up uses an email that already exists.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este e-mail ja esta cadastrado.'**
  String get authErrorUserAlreadyRegistered;

  /// Shown when sign up password is below the minimum accepted length.
  ///
  /// In pt_BR, this message translates to:
  /// **'A senha deve ter pelo menos 6 caracteres.'**
  String get authErrorPasswordTooShort;

  /// Shown when an auth request fails because of a connectivity problem.
  ///
  /// In pt_BR, this message translates to:
  /// **'Falha de conexao. Verifique sua internet e tente novamente.'**
  String get authErrorNetworkFailure;

  /// Generic auth error shown when no specific mapping is available.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nao foi possivel concluir a autenticacao. Tente novamente.'**
  String get authErrorGenericFailure;

  /// Shown when auth is requested before Supabase environment variables are configured.
  ///
  /// In pt_BR, this message translates to:
  /// **'O Supabase nao esta configurado. Defina SUPABASE_URL e SUPABASE_ANON_KEY para habilitar a autenticacao.'**
  String get authErrorUnconfiguredEnvironment;

  /// Title shown on the sign in page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bem-vindo ao FlowDelivery'**
  String get authSignInTitle;

  /// Subtitle shown on the sign in page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pratos deliciosos dos seus restaurantes locais favoritos, entregues na sua porta.'**
  String get authSignInSubtitle;

  /// Title shown on the sign up page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie sua conta FlowDelivery'**
  String get authSignUpTitle;

  /// Subtitle shown on the sign up page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salve seus restaurantes favoritos, acompanhe pedidos e finalize suas compras mais rapido.'**
  String get authSignUpSubtitle;

  /// Title shown on the forgot password page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recupere sua senha'**
  String get authForgotPasswordTitle;

  /// Subtitle shown on the forgot password page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Solicite um link de recuperacao para redefinir sua senha no e-mail informado.'**
  String get authForgotPasswordSubtitle;

  /// Label for auth email fields.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get authEmailLabel;

  /// Label for auth password fields.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha'**
  String get authPasswordLabel;

  /// Placeholder hint for auth email fields.
  ///
  /// In pt_BR, this message translates to:
  /// **'nome@exemplo.com'**
  String get authEmailHint;

  /// Placeholder hint for sign in password field.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite sua senha'**
  String get authSignInPasswordHint;

  /// Placeholder hint for sign up password field.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie uma senha segura'**
  String get authSignUpPasswordHint;

  /// Call to action that navigates to the forgot password page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu a senha?'**
  String get authForgotPasswordCta;

  /// Primary button label for sign in.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get authSignInPrimaryAction;

  /// Primary button label for sign up.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get authSignUpPrimaryAction;

  /// Primary button label for forgot password.
  ///
  /// In pt_BR, this message translates to:
  /// **'Solicitar link de recuperacao'**
  String get authForgotPasswordPrimaryAction;

  /// Secondary navigation label to return to sign in.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar para entrar'**
  String get authForgotPasswordBackAction;

  /// Success banner shown after sign in.
  ///
  /// In pt_BR, this message translates to:
  /// **'Autenticado com sucesso. Redirecionando para o proximo destino.'**
  String get authSignInSuccess;

  /// Success banner shown after sign up.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta criada com sucesso. Redirecionando para o proximo destino.'**
  String get authSignUpSuccess;

  /// Helper text below the forgot password email field.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviaremos um link de recuperacao para este e-mail quando estiver disponivel no seu ambiente.'**
  String get authForgotPasswordHelper;

  /// Informational copy about recovery-link delivery when environment configuration is valid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se o ambiente estiver configurado corretamente, enviaremos o link de recuperacao para o e-mail informado.'**
  String get authForgotPasswordPlaceholderInfo;

  /// Validation message shown when forgot password is submitted without an email.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe seu e-mail para solicitar o link de recuperacao.'**
  String get authForgotPasswordEmptyEmailError;

  /// Success banner shown after requesting password recovery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Link de recuperacao solicitado. Verifique sua caixa de entrada para os proximos passos.'**
  String get authForgotPasswordSuccess;

  /// Default informational banner shown on forgot password page.
  ///
  /// In pt_BR, this message translates to:
  /// **'A recuperacao de senha esta conectada na camada de autenticacao. Use um ambiente configurado valido para enviar o e-mail.'**
  String get authForgotPasswordDefaultBanner;

  /// Title shown on the reset password page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie uma nova senha'**
  String get authResetPasswordTitle;

  /// Subtitle shown on the reset password page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Defina uma nova senha depois de abrir o link de recuperacao enviado para o seu e-mail.'**
  String get authResetPasswordSubtitle;

  /// Label for the reset password confirmation field.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar senha'**
  String get authResetPasswordConfirmLabel;

  /// Placeholder hint for the reset password field.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite a nova senha'**
  String get authResetPasswordPasswordHint;

  /// Placeholder hint for the reset password confirmation field.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repita a nova senha'**
  String get authResetPasswordConfirmHint;

  /// Primary button label for reset password.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualizar senha'**
  String get authResetPasswordPrimaryAction;

  /// Validation message shown when reset password is submitted without a password.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe a nova senha para continuar.'**
  String get authResetPasswordEmptyPasswordError;

  /// Validation message shown when reset password and confirmation do not match.
  ///
  /// In pt_BR, this message translates to:
  /// **'As senhas informadas nao conferem.'**
  String get authResetPasswordMismatchError;

  /// Success banner shown after resetting the password.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha atualizada com sucesso. Volte para entrar com a nova senha.'**
  String get authResetPasswordSuccess;

  /// Secondary navigation label to return to sign in from reset password.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar para entrar'**
  String get authResetPasswordBackAction;

  /// Leading legal text shown on sign in page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ao continuar, voce concorda com nossos '**
  String get authSignInLegalLeading;

  /// Leading legal text shown on sign up page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ao criar uma conta, voce concorda com nossos '**
  String get authSignUpLegalLeading;

  /// Leading legal text shown on forgot password page.
  ///
  /// In pt_BR, this message translates to:
  /// **'Precisa de ajuda? Consulte nossos '**
  String get authForgotPasswordLegalLeading;

  /// Clickable legal terms label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos de Servico'**
  String get authLegalTerms;

  /// Divider label above social auth providers.
  ///
  /// In pt_BR, this message translates to:
  /// **'ou continue com'**
  String get authSocialDivider;

  /// Label for the Google social sign-in button.
  ///
  /// In pt_BR, this message translates to:
  /// **'Google'**
  String get authSocialGoogle;

  /// Label for the Apple social sign-in button.
  ///
  /// In pt_BR, this message translates to:
  /// **'Apple'**
  String get authSocialApple;

  /// Message shown while social auth is not yet implemented.
  ///
  /// In pt_BR, this message translates to:
  /// **'Login social em breve.'**
  String get authSocialComingSoon;

  /// Temporary home placeholder label while the authenticated app shell is not implemented.
  ///
  /// In pt_BR, this message translates to:
  /// **'Home'**
  String get appHomePlaceholder;

  /// Sign in tab label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get authTabSignIn;

  /// Sign up tab label.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get authTabSignUp;

  /// Placeholder tab label for reports.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relatorios'**
  String get authTabReports;

  /// Label shown above the current delivery address in the Home header.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entregar em'**
  String get homeDeliveryAddressLabel;

  /// Current delivery address shown in the Home header.
  ///
  /// In pt_BR, this message translates to:
  /// **'{address}'**
  String homeDeliveryAddressValue(String address);

  /// Hint text shown in the Home search field.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar pratos ou restaurantes'**
  String get homeSearchHint;

  /// Label for the all category chip on the Home feed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos'**
  String get homeCategoryAll;

  /// Label for the burgers category chip on the Home feed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hamburgueres'**
  String get homeCategoryBurgers;

  /// Label for the pizza category chip on the Home feed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pizza'**
  String get homeCategoryPizza;

  /// Label for the sushi category chip on the Home feed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sushi'**
  String get homeCategorySushi;

  /// Label for the healthy category chip on the Home feed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saudavel'**
  String get homeCategoryHealthy;

  /// Title shown in the Home promotion banner.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ofertas para o seu proximo pedido'**
  String get homeBannerTitle;

  /// Discount label shown in the Home promotion banner.
  ///
  /// In pt_BR, this message translates to:
  /// **'{discountPercentage}% OFF'**
  String homeBannerDiscountValue(int discountPercentage);

  /// Badge shown when the Home promotion includes free delivery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrega gratis'**
  String get homeBannerFreeDeliveryBadge;

  /// Section title shown above featured restaurants on the Home feed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Restaurantes em destaque'**
  String get homeFeaturedSectionTitle;

  /// Action label used to reveal the complete section content on Home.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver todos'**
  String get homeSeeAllAction;

  /// Compact restaurant metadata string with rating and delivery time range.
  ///
  /// In pt_BR, this message translates to:
  /// **'{rating} • {minMinutes}-{maxMinutes} min'**
  String homeRestaurantRatingAndDelivery(
    double rating,
    int minMinutes,
    int maxMinutes,
  );

  /// Title shown while the Home remote feed is loading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregando sua Home'**
  String get homeLoadingStateTitle;

  /// Body copy shown while the Home remote feed is loading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estamos buscando os restaurantes e as ofertas mais recentes para voce.'**
  String get homeLoadingStateMessage;

  /// Semantic label announced for the Home loading indicator.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregando feed da Home'**
  String get homeLoadingStateSemanticLabel;

  /// Title shown when the Home remote feed fails to load.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nao foi possivel carregar sua Home'**
  String get homeErrorStateTitle;

  /// Body copy shown when the Home remote feed fails to load.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tente novamente para atualizar restaurantes e ofertas.'**
  String get homeErrorStateMessage;

  /// Retry button label shown after a Home remote feed loading failure.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get homeRetryAction;

  /// Title shown when the Home remote feed loads without featured restaurants.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nada em destaque agora'**
  String get homeEmptyStateTitle;

  /// Body copy shown when the Home remote feed loads without featured restaurants.
  ///
  /// In pt_BR, this message translates to:
  /// **'Volte em instantes para conferir novos restaurantes e ofertas.'**
  String get homeEmptyStateMessage;

  /// Bottom navigation label for the Home destination.
  ///
  /// In pt_BR, this message translates to:
  /// **'Home'**
  String get homeBottomNavHome;

  /// Bottom navigation label for the browse destination.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar'**
  String get homeBottomNavBrowse;

  /// Bottom navigation label for the orders destination.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pedidos'**
  String get homeBottomNavOrders;

  /// Bottom navigation label for the account destination.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta'**
  String get homeBottomNavAccount;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
