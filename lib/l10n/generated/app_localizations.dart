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
  /// **'Esta primeira versao adiciona o ponto de entrada de recuperacao enquanto o fluxo completo ainda aguarda aprovacao.'**
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

  /// Informational copy about the staged rollout of the recovery flow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando o fluxo real de recuperacao for aprovado, esta tela chamara a camada de autenticacao em vez de atuar apenas como placeholder visual.'**
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
