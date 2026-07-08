import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/orders/presentation/providers/order_history_providers.dart';
import 'package:flowdelivery_app/features/orders/presentation/widgets/order_history_sections.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({this.onExploreRestaurants, super.key});

  final VoidCallback? onExploreRestaurants;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrders = ref.watch(orderHistoryProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ordersPageTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.contentMaxWidthMd,
              ),
              child: asyncOrders.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return OrderHistoryStateCard(
                      icon: Icons.receipt_long_outlined,
                      title: l10n.ordersEmptyTitle,
                      message: l10n.ordersEmptyMessage,
                      action: FilledButton.icon(
                        onPressed: onExploreRestaurants,
                        icon: const Icon(
                          Icons.storefront_outlined,
                          size: AppSizes.iconMd,
                        ),
                        label: Text(l10n.ordersEmptyAction),
                      ),
                    );
                  }

                  return OrderHistoryList(orders: orders);
                },
                error: (error, stackTrace) {
                  return OrderHistoryStateCard(
                    icon: Icons.cloud_off_outlined,
                    title: l10n.ordersErrorTitle,
                    message: l10n.ordersErrorMessage,
                    action: FilledButton.icon(
                      onPressed: () => ref.invalidate(orderHistoryProvider),
                      icon: const Icon(Icons.refresh, size: AppSizes.iconLg),
                      label: Text(l10n.ordersRetryAction),
                    ),
                  );
                },
                loading: () {
                  return OrderHistoryLoadingState(
                    semanticLabel: l10n.ordersLoadingSemanticLabel,
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
