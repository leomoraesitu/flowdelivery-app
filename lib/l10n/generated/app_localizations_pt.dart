// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get authErrorInvalidCredentials => 'E-mail ou senha invalidos.';

  @override
  String get authErrorEmailNotConfirmed =>
      'Confirme seu e-mail antes de entrar.';

  @override
  String get authErrorUserAlreadyRegistered =>
      'Este e-mail ja esta cadastrado.';

  @override
  String get authErrorPasswordTooShort =>
      'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get authErrorNetworkFailure =>
      'Falha de conexao. Verifique sua internet e tente novamente.';

  @override
  String get authErrorGenericFailure =>
      'Nao foi possivel concluir a autenticacao. Tente novamente.';

  @override
  String get authErrorUnconfiguredEnvironment =>
      'O Supabase nao esta configurado. Defina SUPABASE_URL e SUPABASE_ANON_KEY para habilitar a autenticacao.';

  @override
  String get authSignInTitle => 'Bem-vindo ao FlowDelivery';

  @override
  String get authSignInSubtitle =>
      'Pratos deliciosos dos seus restaurantes locais favoritos, entregues na sua porta.';

  @override
  String get authSignUpTitle => 'Crie sua conta FlowDelivery';

  @override
  String get authSignUpSubtitle =>
      'Salve seus restaurantes favoritos, acompanhe pedidos e finalize suas compras mais rapido.';

  @override
  String get authForgotPasswordTitle => 'Recupere sua senha';

  @override
  String get authForgotPasswordSubtitle =>
      'Esta primeira versao adiciona o ponto de entrada de recuperacao enquanto o fluxo completo ainda aguarda aprovacao.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authEmailHint => 'nome@exemplo.com';

  @override
  String get authSignInPasswordHint => 'Digite sua senha';

  @override
  String get authSignUpPasswordHint => 'Crie uma senha segura';

  @override
  String get authForgotPasswordCta => 'Esqueceu a senha?';

  @override
  String get authSignInPrimaryAction => 'Entrar';

  @override
  String get authSignUpPrimaryAction => 'Criar conta';

  @override
  String get authForgotPasswordPrimaryAction => 'Solicitar link de recuperacao';

  @override
  String get authForgotPasswordBackAction => 'Voltar para entrar';

  @override
  String get authSignInSuccess =>
      'Autenticado com sucesso. Redirecionando para o proximo destino.';

  @override
  String get authSignUpSuccess =>
      'Conta criada com sucesso. Redirecionando para o proximo destino.';

  @override
  String get authForgotPasswordHelper =>
      'Enviaremos um link de recuperacao para este e-mail quando estiver disponivel no seu ambiente.';

  @override
  String get authForgotPasswordPlaceholderInfo =>
      'Quando o fluxo real de recuperacao for aprovado, esta tela chamara a camada de autenticacao em vez de atuar apenas como placeholder visual.';

  @override
  String get authForgotPasswordEmptyEmailError =>
      'Informe seu e-mail para solicitar o link de recuperacao.';

  @override
  String get authForgotPasswordSuccess =>
      'Link de recuperacao solicitado. Verifique sua caixa de entrada para os proximos passos.';

  @override
  String get authForgotPasswordDefaultBanner =>
      'A recuperacao de senha esta conectada na camada de autenticacao. Use um ambiente configurado valido para enviar o e-mail.';

  @override
  String get authSignInLegalLeading =>
      'Ao continuar, voce concorda com nossos ';

  @override
  String get authSignUpLegalLeading =>
      'Ao criar uma conta, voce concorda com nossos ';

  @override
  String get authForgotPasswordLegalLeading =>
      'Precisa de ajuda imediata? Consulte nossos ';

  @override
  String get authLegalTerms => 'Termos de Servico';

  @override
  String get authSocialDivider => 'ou continue com';

  @override
  String get authSocialGoogle => 'Google';

  @override
  String get authSocialApple => 'Apple';

  @override
  String get authSocialComingSoon => 'Login social em breve.';

  @override
  String get appHomePlaceholder => 'Home';

  @override
  String get authTabSignIn => 'Entrar';

  @override
  String get authTabSignUp => 'Criar conta';

  @override
  String get authTabReports => 'Relatorios';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get authErrorInvalidCredentials => 'E-mail ou senha invalidos.';

  @override
  String get authErrorEmailNotConfirmed =>
      'Confirme seu e-mail antes de entrar.';

  @override
  String get authErrorUserAlreadyRegistered =>
      'Este e-mail ja esta cadastrado.';

  @override
  String get authErrorPasswordTooShort =>
      'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get authErrorNetworkFailure =>
      'Falha de conexao. Verifique sua internet e tente novamente.';

  @override
  String get authErrorGenericFailure =>
      'Nao foi possivel concluir a autenticacao. Tente novamente.';

  @override
  String get authErrorUnconfiguredEnvironment =>
      'O Supabase nao esta configurado. Defina SUPABASE_URL e SUPABASE_ANON_KEY para habilitar a autenticacao.';

  @override
  String get authSignInTitle => 'Bem-vindo ao FlowDelivery';

  @override
  String get authSignInSubtitle =>
      'Pratos deliciosos dos seus restaurantes locais favoritos, entregues na sua porta.';

  @override
  String get authSignUpTitle => 'Crie sua conta FlowDelivery';

  @override
  String get authSignUpSubtitle =>
      'Salve seus restaurantes favoritos, acompanhe pedidos e finalize suas compras mais rapido.';

  @override
  String get authForgotPasswordTitle => 'Recupere sua senha';

  @override
  String get authForgotPasswordSubtitle =>
      'Esta primeira versao adiciona o ponto de entrada de recuperacao enquanto o fluxo completo ainda aguarda aprovacao.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authEmailHint => 'nome@exemplo.com';

  @override
  String get authSignInPasswordHint => 'Digite sua senha';

  @override
  String get authSignUpPasswordHint => 'Crie uma senha segura';

  @override
  String get authForgotPasswordCta => 'Esqueceu a senha?';

  @override
  String get authSignInPrimaryAction => 'Entrar';

  @override
  String get authSignUpPrimaryAction => 'Criar conta';

  @override
  String get authForgotPasswordPrimaryAction => 'Solicitar link de recuperacao';

  @override
  String get authForgotPasswordBackAction => 'Voltar para entrar';

  @override
  String get authSignInSuccess =>
      'Autenticado com sucesso. Redirecionando para o proximo destino.';

  @override
  String get authSignUpSuccess =>
      'Conta criada com sucesso. Redirecionando para o proximo destino.';

  @override
  String get authForgotPasswordHelper =>
      'Enviaremos um link de recuperacao para este e-mail quando estiver disponivel no seu ambiente.';

  @override
  String get authForgotPasswordPlaceholderInfo =>
      'Quando o fluxo real de recuperacao for aprovado, esta tela chamara a camada de autenticacao em vez de atuar apenas como placeholder visual.';

  @override
  String get authForgotPasswordEmptyEmailError =>
      'Informe seu e-mail para solicitar o link de recuperacao.';

  @override
  String get authForgotPasswordSuccess =>
      'Link de recuperacao solicitado. Verifique sua caixa de entrada para os proximos passos.';

  @override
  String get authForgotPasswordDefaultBanner =>
      'A recuperacao de senha esta conectada na camada de autenticacao. Use um ambiente configurado valido para enviar o e-mail.';

  @override
  String get authSignInLegalLeading =>
      'Ao continuar, voce concorda com nossos ';

  @override
  String get authSignUpLegalLeading =>
      'Ao criar uma conta, voce concorda com nossos ';

  @override
  String get authForgotPasswordLegalLeading =>
      'Precisa de ajuda imediata? Consulte nossos ';

  @override
  String get authLegalTerms => 'Termos de Servico';

  @override
  String get authSocialDivider => 'ou continue com';

  @override
  String get authSocialGoogle => 'Google';

  @override
  String get authSocialApple => 'Apple';

  @override
  String get authSocialComingSoon => 'Login social em breve.';

  @override
  String get appHomePlaceholder => 'Home';

  @override
  String get authTabSignIn => 'Entrar';

  @override
  String get authTabSignUp => 'Criar conta';

  @override
  String get authTabReports => 'Relatorios';
}
