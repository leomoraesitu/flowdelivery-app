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
      'Solicite um link de recuperacao para redefinir sua senha no e-mail informado.';

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
      'Se o ambiente estiver configurado corretamente, enviaremos o link de recuperacao para o e-mail informado.';

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
  String get authResetPasswordTitle => 'Crie uma nova senha';

  @override
  String get authResetPasswordSubtitle =>
      'Defina uma nova senha depois de abrir o link de recuperacao enviado para o seu e-mail.';

  @override
  String get authResetPasswordConfirmLabel => 'Confirmar senha';

  @override
  String get authResetPasswordPasswordHint => 'Digite a nova senha';

  @override
  String get authResetPasswordConfirmHint => 'Repita a nova senha';

  @override
  String get authResetPasswordPrimaryAction => 'Atualizar senha';

  @override
  String get authResetPasswordEmptyPasswordError =>
      'Informe a nova senha para continuar.';

  @override
  String get authResetPasswordMismatchError =>
      'As senhas informadas nao conferem.';

  @override
  String get authResetPasswordSuccess =>
      'Senha atualizada com sucesso. Volte para entrar com a nova senha.';

  @override
  String get authResetPasswordBackAction => 'Voltar para entrar';

  @override
  String get authSignInLegalLeading =>
      'Ao continuar, voce concorda com nossos ';

  @override
  String get authSignUpLegalLeading =>
      'Ao criar uma conta, voce concorda com nossos ';

  @override
  String get authForgotPasswordLegalLeading =>
      'Precisa de ajuda? Consulte nossos ';

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

  @override
  String get homeDeliveryAddressLabel => 'Entregar em';

  @override
  String homeDeliveryAddressValue(String address) {
    return '$address';
  }

  @override
  String get homeSearchHint => 'Buscar pratos ou restaurantes';

  @override
  String get homeCategoryAll => 'Todos';

  @override
  String get homeCategoryBurgers => 'Hamburgueres';

  @override
  String get homeCategoryPizza => 'Pizza';

  @override
  String get homeCategorySushi => 'Sushi';

  @override
  String get homeCategoryHealthy => 'Saudavel';

  @override
  String get homeBannerTitle => 'Ofertas para o seu proximo pedido';

  @override
  String homeBannerDiscountValue(int discountPercentage) {
    return '$discountPercentage% OFF';
  }

  @override
  String get homeBannerFreeDeliveryBadge => 'Entrega gratis';

  @override
  String get homeFeaturedSectionTitle => 'Restaurantes em destaque';

  @override
  String get homeSeeAllAction => 'Ver todos';

  @override
  String homeRestaurantRatingAndDelivery(
    double rating,
    int minMinutes,
    int maxMinutes,
  ) {
    return '$rating • $minMinutes-$maxMinutes min';
  }

  @override
  String get homeLoadingStateTitle => 'Carregando sua Home';

  @override
  String get homeLoadingStateMessage =>
      'Estamos buscando os restaurantes e as ofertas mais recentes para voce.';

  @override
  String get homeLoadingStateSemanticLabel => 'Carregando feed da Home';

  @override
  String get homeErrorStateTitle => 'Nao foi possivel carregar sua Home';

  @override
  String get homeErrorStateMessage =>
      'Tente novamente para atualizar restaurantes e ofertas.';

  @override
  String get homeRetryAction => 'Tentar novamente';

  @override
  String get homeEmptyStateTitle => 'Nada em destaque agora';

  @override
  String get homeEmptyStateMessage =>
      'Volte em instantes para conferir novos restaurantes e ofertas.';

  @override
  String get homeDiscoveryEmptyStateTitle => 'Nenhum restaurante encontrado';

  @override
  String get homeDiscoveryEmptyStateMessage =>
      'Tente ajustar sua busca ou limpar os filtros para ver mais opcoes.';

  @override
  String get homeDiscoveryClearFiltersAction => 'Limpar filtros';

  @override
  String get restaurantDetailsBackAction => 'Voltar';

  @override
  String get restaurantDetailsLoadingStateTitle => 'Carregando restaurante';

  @override
  String get restaurantDetailsLoadingStateMessage =>
      'Estamos buscando o cardapio e os detalhes mais recentes para voce.';

  @override
  String get restaurantDetailsLoadingStateSemanticLabel =>
      'Carregando detalhes e cardapio do restaurante';

  @override
  String get restaurantDetailsErrorStateTitle =>
      'Nao foi possivel carregar o restaurante';

  @override
  String get restaurantDetailsErrorStateMessage =>
      'Tente novamente para atualizar os detalhes e o cardapio.';

  @override
  String get restaurantDetailsRetryAction => 'Tentar novamente';

  @override
  String get restaurantDetailsEmptyStateTitle => 'Cardapio indisponivel agora';

  @override
  String get restaurantDetailsEmptyStateMessage =>
      'Volte em instantes para conferir as opcoes deste restaurante.';

  @override
  String get restaurantDetailsMenuSectionTitle => 'Cardapio';

  @override
  String get restaurantDetailsCategoryPopular => 'Populares';

  @override
  String get restaurantDetailsCategoryBurgers => 'Hamburgueres';

  @override
  String get restaurantDetailsCategorySides => 'Acompanhamentos';

  @override
  String get restaurantDetailsCategoryDrinks => 'Bebidas';

  @override
  String get restaurantDetailsCategorySalads => 'Saladas';

  @override
  String get restaurantDetailsCategoryPastas => 'Massas';

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
    return 'Cardapio de $restaurantName';
  }

  @override
  String restaurantDetailsCategoryFilterSemanticLabel(String categoryName) {
    return 'Filtrar cardapio por $categoryName';
  }

  @override
  String get homeBottomNavHome => 'Home';

  @override
  String get homeBottomNavBrowse => 'Buscar';

  @override
  String get homeBottomNavOrders => 'Pedidos';

  @override
  String get homeBottomNavAccount => 'Conta';

  @override
  String get productDetailsBackAction => 'Voltar';

  @override
  String get productDetailsLoadingStateTitle => 'Carregando produto';

  @override
  String get productDetailsLoadingStateMessage =>
      'Estamos buscando os detalhes mais recentes deste produto.';

  @override
  String get productDetailsLoadingStateSemanticLabel =>
      'Carregando detalhes do produto';

  @override
  String get productDetailsErrorStateTitle =>
      'Nao foi possivel carregar o produto';

  @override
  String get productDetailsErrorStateMessage =>
      'Tente novamente para atualizar os detalhes do produto.';

  @override
  String get productDetailsRetryAction => 'Tentar novamente';

  @override
  String get productDetailsNotFoundStateTitle => 'Produto indisponivel';

  @override
  String get productDetailsNotFoundStateMessage =>
      'Este produto nao esta disponivel neste restaurante.';

  @override
  String productDetailsImageSemanticLabel(String productName) {
    return 'Imagem de $productName';
  }

  @override
  String productDetailsPriceSemanticLabel(String price) {
    return 'Preco $price';
  }

  @override
  String get cartTitle => 'Meu Carrinho';

  @override
  String get cartEmptyTitle => 'Carrinho vazio';

  @override
  String get cartEmptyMessage =>
      'Adicione itens de um restaurante para comecar seu pedido.';

  @override
  String get cartEmptyAction => 'Explorar restaurantes';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartClearAction => 'Limpar carrinho';

  @override
  String get cartRemoveItem => 'Remover item';

  @override
  String get cartIncreaseQuantity => 'Aumentar quantidade';

  @override
  String get cartDecreaseQuantity => 'Diminuir quantidade';

  @override
  String get cartProceedToCheckout => 'Ir para o checkout';

  @override
  String get cartCheckoutPlaceholder => 'Checkout em breve';

  @override
  String get cartAddToCart => 'Adicionar ao carrinho';

  @override
  String get cartUpdateQuantity => 'Atualizar quantidade';

  @override
  String get cartAlreadyInCart => 'No carrinho';

  @override
  String get cartDifferentRestaurantTitle => 'Iniciar novo pedido?';

  @override
  String get cartDifferentRestaurantMessage =>
      'Seu carrinho tem itens de outro restaurante. Deseja limpa-lo e adicionar este item?';

  @override
  String get cartDifferentRestaurantConfirm => 'Sim, limpar';

  @override
  String get cartDifferentRestaurantCancel => 'Cancelar';

  @override
  String cartItemImageSemanticLabel(String name) {
    return 'Imagem de $name';
  }
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
      'Solicite um link de recuperacao para redefinir sua senha no e-mail informado.';

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
      'Se o ambiente estiver configurado corretamente, enviaremos o link de recuperacao para o e-mail informado.';

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
  String get authResetPasswordTitle => 'Crie uma nova senha';

  @override
  String get authResetPasswordSubtitle =>
      'Defina uma nova senha depois de abrir o link de recuperacao enviado para o seu e-mail.';

  @override
  String get authResetPasswordConfirmLabel => 'Confirmar senha';

  @override
  String get authResetPasswordPasswordHint => 'Digite a nova senha';

  @override
  String get authResetPasswordConfirmHint => 'Repita a nova senha';

  @override
  String get authResetPasswordPrimaryAction => 'Atualizar senha';

  @override
  String get authResetPasswordEmptyPasswordError =>
      'Informe a nova senha para continuar.';

  @override
  String get authResetPasswordMismatchError =>
      'As senhas informadas nao conferem.';

  @override
  String get authResetPasswordSuccess =>
      'Senha atualizada com sucesso. Volte para entrar com a nova senha.';

  @override
  String get authResetPasswordBackAction => 'Voltar para entrar';

  @override
  String get authSignInLegalLeading =>
      'Ao continuar, voce concorda com nossos ';

  @override
  String get authSignUpLegalLeading =>
      'Ao criar uma conta, voce concorda com nossos ';

  @override
  String get authForgotPasswordLegalLeading =>
      'Precisa de ajuda? Consulte nossos ';

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

  @override
  String get homeDeliveryAddressLabel => 'Entregar em';

  @override
  String homeDeliveryAddressValue(String address) {
    return '$address';
  }

  @override
  String get homeSearchHint => 'Buscar pratos ou restaurantes';

  @override
  String get homeCategoryAll => 'Todos';

  @override
  String get homeCategoryBurgers => 'Hamburgueres';

  @override
  String get homeCategoryPizza => 'Pizza';

  @override
  String get homeCategorySushi => 'Sushi';

  @override
  String get homeCategoryHealthy => 'Saudavel';

  @override
  String get homeBannerTitle => 'Ofertas para o seu proximo pedido';

  @override
  String homeBannerDiscountValue(int discountPercentage) {
    return '$discountPercentage% OFF';
  }

  @override
  String get homeBannerFreeDeliveryBadge => 'Entrega gratis';

  @override
  String get homeFeaturedSectionTitle => 'Restaurantes em destaque';

  @override
  String get homeSeeAllAction => 'Ver todos';

  @override
  String homeRestaurantRatingAndDelivery(
    double rating,
    int minMinutes,
    int maxMinutes,
  ) {
    return '$rating • $minMinutes-$maxMinutes min';
  }

  @override
  String get homeLoadingStateTitle => 'Carregando sua Home';

  @override
  String get homeLoadingStateMessage =>
      'Estamos buscando os restaurantes e as ofertas mais recentes para voce.';

  @override
  String get homeLoadingStateSemanticLabel => 'Carregando feed da Home';

  @override
  String get homeErrorStateTitle => 'Nao foi possivel carregar sua Home';

  @override
  String get homeErrorStateMessage =>
      'Tente novamente para atualizar restaurantes e ofertas.';

  @override
  String get homeRetryAction => 'Tentar novamente';

  @override
  String get homeEmptyStateTitle => 'Nada em destaque agora';

  @override
  String get homeEmptyStateMessage =>
      'Volte em instantes para conferir novos restaurantes e ofertas.';

  @override
  String get homeDiscoveryEmptyStateTitle => 'Nenhum restaurante encontrado';

  @override
  String get homeDiscoveryEmptyStateMessage =>
      'Tente ajustar sua busca ou limpar os filtros para ver mais opcoes.';

  @override
  String get homeDiscoveryClearFiltersAction => 'Limpar filtros';

  @override
  String get restaurantDetailsBackAction => 'Voltar';

  @override
  String get restaurantDetailsLoadingStateTitle => 'Carregando restaurante';

  @override
  String get restaurantDetailsLoadingStateMessage =>
      'Estamos buscando o cardapio e os detalhes mais recentes para voce.';

  @override
  String get restaurantDetailsLoadingStateSemanticLabel =>
      'Carregando detalhes e cardapio do restaurante';

  @override
  String get restaurantDetailsErrorStateTitle =>
      'Nao foi possivel carregar o restaurante';

  @override
  String get restaurantDetailsErrorStateMessage =>
      'Tente novamente para atualizar os detalhes e o cardapio.';

  @override
  String get restaurantDetailsRetryAction => 'Tentar novamente';

  @override
  String get restaurantDetailsEmptyStateTitle => 'Cardapio indisponivel agora';

  @override
  String get restaurantDetailsEmptyStateMessage =>
      'Volte em instantes para conferir as opcoes deste restaurante.';

  @override
  String get restaurantDetailsMenuSectionTitle => 'Cardapio';

  @override
  String get restaurantDetailsCategoryPopular => 'Populares';

  @override
  String get restaurantDetailsCategoryBurgers => 'Hamburgueres';

  @override
  String get restaurantDetailsCategorySides => 'Acompanhamentos';

  @override
  String get restaurantDetailsCategoryDrinks => 'Bebidas';

  @override
  String get restaurantDetailsCategorySalads => 'Saladas';

  @override
  String get restaurantDetailsCategoryPastas => 'Massas';

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
    return 'Cardapio de $restaurantName';
  }

  @override
  String restaurantDetailsCategoryFilterSemanticLabel(String categoryName) {
    return 'Filtrar cardapio por $categoryName';
  }

  @override
  String get homeBottomNavHome => 'Home';

  @override
  String get homeBottomNavBrowse => 'Buscar';

  @override
  String get homeBottomNavOrders => 'Pedidos';

  @override
  String get homeBottomNavAccount => 'Conta';

  @override
  String get productDetailsBackAction => 'Voltar';

  @override
  String get productDetailsLoadingStateTitle => 'Carregando produto';

  @override
  String get productDetailsLoadingStateMessage =>
      'Estamos buscando os detalhes mais recentes deste produto.';

  @override
  String get productDetailsLoadingStateSemanticLabel =>
      'Carregando detalhes do produto';

  @override
  String get productDetailsErrorStateTitle =>
      'Nao foi possivel carregar o produto';

  @override
  String get productDetailsErrorStateMessage =>
      'Tente novamente para atualizar os detalhes do produto.';

  @override
  String get productDetailsRetryAction => 'Tentar novamente';

  @override
  String get productDetailsNotFoundStateTitle => 'Produto indisponivel';

  @override
  String get productDetailsNotFoundStateMessage =>
      'Este produto nao esta disponivel neste restaurante.';

  @override
  String productDetailsImageSemanticLabel(String productName) {
    return 'Imagem de $productName';
  }

  @override
  String productDetailsPriceSemanticLabel(String price) {
    return 'Preco $price';
  }

  @override
  String get cartTitle => 'Meu Carrinho';

  @override
  String get cartEmptyTitle => 'Carrinho vazio';

  @override
  String get cartEmptyMessage =>
      'Adicione itens de um restaurante para comecar seu pedido.';

  @override
  String get cartEmptyAction => 'Explorar restaurantes';

  @override
  String cartItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartClearAction => 'Limpar carrinho';

  @override
  String get cartRemoveItem => 'Remover item';

  @override
  String get cartIncreaseQuantity => 'Aumentar quantidade';

  @override
  String get cartDecreaseQuantity => 'Diminuir quantidade';

  @override
  String get cartProceedToCheckout => 'Ir para o checkout';

  @override
  String get cartCheckoutPlaceholder => 'Checkout em breve';

  @override
  String get cartAddToCart => 'Adicionar ao carrinho';

  @override
  String get cartUpdateQuantity => 'Atualizar quantidade';

  @override
  String get cartAlreadyInCart => 'No carrinho';

  @override
  String get cartDifferentRestaurantTitle => 'Iniciar novo pedido?';

  @override
  String get cartDifferentRestaurantMessage =>
      'Seu carrinho tem itens de outro restaurante. Deseja limpa-lo e adicionar este item?';

  @override
  String get cartDifferentRestaurantConfirm => 'Sim, limpar';

  @override
  String get cartDifferentRestaurantCancel => 'Cancelar';

  @override
  String cartItemImageSemanticLabel(String name) {
    return 'Imagem de $name';
  }
}
