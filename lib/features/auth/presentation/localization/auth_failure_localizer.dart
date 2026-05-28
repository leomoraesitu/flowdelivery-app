import 'package:flowdelivery_app/features/auth/domain/failures/auth_failure.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';

extension AuthFailureLocalizer on AuthFailure {
  String localized(AppLocalizations l10n) {
    return switch (code) {
      AuthFailureCode.invalidCredentials => l10n.authErrorInvalidCredentials,
      AuthFailureCode.emailNotConfirmed => l10n.authErrorEmailNotConfirmed,
      AuthFailureCode.userAlreadyRegistered =>
        l10n.authErrorUserAlreadyRegistered,
      AuthFailureCode.passwordTooShort => l10n.authErrorPasswordTooShort,
      AuthFailureCode.networkFailure => l10n.authErrorNetworkFailure,
      AuthFailureCode.unconfiguredEnvironment =>
        l10n.authErrorUnconfiguredEnvironment,
      AuthFailureCode.genericFailure =>
        fallbackMessage ?? l10n.authErrorGenericFailure,
    };
  }
}