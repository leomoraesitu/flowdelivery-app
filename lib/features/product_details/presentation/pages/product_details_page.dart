import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/cart/presentation/widgets/cart_badge_button.dart';
import 'package:flowdelivery_app/features/cart/presentation/widgets/cart_sections.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/features/product_details/presentation/providers/product_details_providers.dart';
import 'package:flowdelivery_app/features/product_details/presentation/widgets/product_details_sections.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({
    required this.productId,
    this.onBack,
    this.onOpenCart,
    super.key,
  });

  final String productId;
  final VoidCallback? onBack;
  final VoidCallback? onOpenCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProduct = ref.watch(productDetailsProvider(productId));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.contentMaxWidthMd,
              ),
              child: asyncProduct.when(
                data: (product) {
                  if (product == null) {
                    return ProductDetailsStateCard(
                      icon: Icons.search_off_outlined,
                      title: l10n.productDetailsNotFoundStateTitle,
                      message: l10n.productDetailsNotFoundStateMessage,
                      action: OutlinedButton.icon(
                        onPressed:
                            onBack ?? () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: AppSizes.iconLg,
                        ),
                        label: Text(l10n.productDetailsBackAction),
                      ),
                    );
                  }

                  return ProductDetailsSections(
                    product: product,
                    onBack: onBack ?? () => Navigator.of(context).maybePop(),
                    cartAction: _CartActionArea(product: product),
                    headerAction: onOpenCart == null
                        ? null
                        : CartBadgeButton(onPressed: onOpenCart!),
                  );
                },
                error: (error, stackTrace) {
                  return ProductDetailsStateCard(
                    icon: Icons.cloud_off_outlined,
                    title: l10n.productDetailsErrorStateTitle,
                    message: l10n.productDetailsErrorStateMessage,
                    action: FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(productDetailsProvider(productId));
                      },
                      icon: const Icon(Icons.refresh, size: AppSizes.iconLg),
                      label: Text(l10n.productDetailsRetryAction),
                    ),
                  );
                },
                loading: () {
                  return ProductDetailsLoadingState(
                    title: l10n.productDetailsLoadingStateTitle,
                    message: l10n.productDetailsLoadingStateMessage,
                    semanticLabel: l10n.productDetailsLoadingStateSemanticLabel,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartActionArea extends ConsumerWidget {
  const _CartActionArea({required this.product});

  final ProductDetails product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItem = ref.watch(cartItemProvider(product.id));
    final l10n = AppLocalizations.of(context);

    if (cartItem == null) {
      return FilledButton.icon(
        onPressed: () => _addToCart(context, ref),
        icon: const Icon(
          Icons.add_shopping_cart_outlined,
          size: AppSizes.iconMd,
        ),
        label: Text(l10n.cartAddToCart),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.cartAlreadyInCart,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Semantics(
          label: l10n.cartUpdateQuantity,
          child: CartQuantityControl(
            quantity: cartItem.quantity,
            onIncrease: () => ref
                .read(cartProvider.notifier)
                .updateQuantity(product.id, cartItem.quantity + 1),
            onDecrease: () => ref
                .read(cartProvider.notifier)
                .updateQuantity(product.id, cartItem.quantity - 1),
          ),
        ),
      ],
    );
  }

  Future<void> _addToCart(BuildContext context, WidgetRef ref) async {
    final cartNotifier = ref.read(cartProvider.notifier);
    final result = cartNotifier.addItem(product);

    if (result != CartAddResult.requiresConfirmation) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cartDifferentRestaurantTitle),
        content: Text(l10n.cartDifferentRestaurantMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cartDifferentRestaurantCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.cartDifferentRestaurantConfirm),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      cartNotifier
        ..clear()
        ..addItem(product);
    }
  }
}
