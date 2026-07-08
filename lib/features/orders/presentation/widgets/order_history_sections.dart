import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/orders/domain/entities/order_history_entry.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flowdelivery_app/shared/presentation/widgets/app_media_image.dart';
import 'package:flowdelivery_app/shared/utils/price_formatter.dart';
import 'package:flutter/material.dart';

class OrderHistoryLoadingState extends StatelessWidget {
  const OrderHistoryLoadingState({required this.semanticLabel, super.key});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Semantics(
        label: semanticLabel,
        liveRegion: true,
        child: Center(
          child: SizedBox.square(
            dimension: AppSizes.touchTarget,
            child: CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}

class OrderHistoryStateCard extends StatelessWidget {
  const OrderHistoryStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: AppSizes.touchTarget, color: colorScheme.primary),
          SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (action != null) ...[SizedBox(height: AppSpacing.lg), action!],
        ],
      ),
    );
  }
}

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({required this.orders, super.key});

  final List<OrderHistoryEntry> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return OrderHistoryCard(entry: orders[index]);
      },
    );
  }
}

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({required this.entry, super.key});

  final OrderHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final formattedDate = MaterialLocalizations.of(
      context,
    ).formatMediumDate(entry.createdAt);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: SizedBox.square(
              dimension: AppSizes.menuItemThumbnail,
              child: AppMediaImage(
                source: entry.restaurantImagePath,
                fit: BoxFit.cover,
                fallbackIcon: Icons.restaurant_outlined,
                fallbackIconSize: AppSizes.iconLg,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entry.restaurantName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    _OrderStatusChip(status: entry.status),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  formattedDate,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    Text(
                      l10n.ordersItemCount(entry.itemCount),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.ordersTotalLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          formatPriceInCents(context, entry.totalInCents),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusChip extends StatelessWidget {
  const _OrderStatusChip({required this.status});

  final OrderHistoryStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          _statusLabel(l10n, status),
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, OrderHistoryStatus status) {
    return switch (status) {
      OrderHistoryStatus.placed => l10n.ordersStatusPlaced,
    };
  }
}
