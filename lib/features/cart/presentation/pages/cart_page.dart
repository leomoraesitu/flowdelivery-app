import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/cart/presentation/widgets/cart_sections.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({
    this.onExploreRestaurants,
    this.onProceedToCheckout,
    super.key,
  });

  final VoidCallback? onExploreRestaurants;
  final VoidCallback? onProceedToCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cartTitle),
        actions: [
          if (!cart.isEmpty)
            IconButton(
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              tooltip: l10n.cartClearAction,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.contentMaxWidthMd,
              ),
              child: cart.isEmpty
                  ? CartEmptyState(
                      onExploreRestaurants:
                          onExploreRestaurants ??
                          () => Navigator.of(context).maybePop(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CartItemsHeader(itemCount: cart.itemCount),
                        SizedBox(height: AppSpacing.sm),
                        for (final item in cart.items) ...[
                          CartItemTile(
                            item: item,
                            onIncreaseQuantity: () => ref
                                .read(cartProvider.notifier)
                                .updateQuantity(
                                  item.productId,
                                  item.quantity + 1,
                                ),
                            onDecreaseQuantity: () => ref
                                .read(cartProvider.notifier)
                                .updateQuantity(
                                  item.productId,
                                  item.quantity - 1,
                                ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                        ],
                        SizedBox(height: AppSpacing.xs),
                        const Divider(),
                        SizedBox(height: AppSpacing.xs),
                        CartTotalSection(totalInCents: cart.totalInCents),
                        SizedBox(height: AppSpacing.lg),
                        CartCheckoutSection(
                          onProceedToCheckout: onProceedToCheckout,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
