import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Floating cart action with an item-count badge.
///
/// Watches only [cartItemCountProvider], so cart mutations rebuild this
/// button alone rather than the page hosting it.
class CartBadgeButton extends ConsumerWidget {
  const CartBadgeButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return IconButton.filledTonal(
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
      onPressed: onPressed,
      tooltip: l10n.cartTitle,
      icon: Badge(
        isLabelVisible: itemCount > 0,
        label: Text(itemCount.toString()),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
    );
  }
}
