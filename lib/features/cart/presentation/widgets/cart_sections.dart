import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/cart/domain/entities/cart_item.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flowdelivery_app/shared/presentation/widgets/app_media_image.dart';
import 'package:flowdelivery_app/shared/utils/price_formatter.dart';
import 'package:flutter/material.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({required this.onExploreRestaurants, super.key});

  final VoidCallback onExploreRestaurants;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: AppSizes.touchTarget,
            color: colorScheme.primary,
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            l10n.cartEmptyTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            l10n.cartEmptyMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onExploreRestaurants,
            icon: const Icon(Icons.storefront_outlined, size: AppSizes.iconMd),
            label: Text(l10n.cartEmptyAction),
          ),
        ],
      ),
    );
  }
}

class CartItemsHeader extends StatelessWidget {
  const CartItemsHeader({required this.itemCount, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Text(
      l10n.cartItemCount(itemCount),
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    required this.item,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    super.key,
  });

  final CartItem item;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox.square(
              dimension: AppSizes.menuItemThumbnail,
              child: AppMediaImage(
                source: item.imageAssetPath,
                fit: BoxFit.cover,
                semanticLabel: l10n.cartItemImageSemanticLabel(item.name),
                fallbackIcon: Icons.fastfood_outlined,
                fallbackIconSize: AppSizes.iconLg,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  formatPriceInCents(context, item.priceInCents),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (item.quantity > 1) ...[
                  SizedBox(height: AppSpacing.xxs),
                  Semantics(
                    label: l10n.cartSubtotal,
                    child: Text(
                      formatPriceInCents(context, item.subtotalInCents),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          CartQuantityControl(
            quantity: item.quantity,
            onIncrease: onIncreaseQuantity,
            onDecrease: onDecreaseQuantity,
          ),
        ],
      ),
    );
  }
}

class CartTotalSection extends StatelessWidget {
  const CartTotalSection({required this.totalInCents, super.key});

  final int totalInCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.cartTotal,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          formatPriceInCents(context, totalInCents),
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class CartCheckoutSection extends StatelessWidget {
  const CartCheckoutSection({required this.onProceedToCheckout, super.key});

  final VoidCallback? onProceedToCheckout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: onProceedToCheckout,
          icon: const Icon(Icons.arrow_forward, size: AppSizes.iconMd),
          label: Text(l10n.cartProceedToCheckout),
        ),
      ],
    );
  }
}

class CartQuantityControl extends StatelessWidget {
  const CartQuantityControl({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    super.key,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          onPressed: onDecrease,
          tooltip: quantity > 1 ? l10n.cartDecreaseQuantity : l10n.cartRemoveItem,
          icon: Icon(
            quantity > 1
                ? Icons.remove_circle_outline
                : Icons.delete_outline,
            size: AppSizes.iconMd,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            quantity.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton.filled(
          onPressed: onIncrease,
          tooltip: l10n.cartIncreaseQuantity,
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          icon: const Icon(Icons.add_circle_outline, size: AppSizes.iconMd),
        ),
      ],
    );
  }
}
