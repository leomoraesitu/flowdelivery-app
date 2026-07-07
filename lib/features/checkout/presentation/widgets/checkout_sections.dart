import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flowdelivery_app/shared/utils/price_formatter.dart';
import 'package:flutter/material.dart';

/// Presentation-only view of one order line, so checkout sections do not
/// depend on the cart feature's entities.
class CheckoutSummaryItem {
  const CheckoutSummaryItem({
    required this.name,
    required this.quantity,
    required this.subtotalInCents,
  });

  final String name;
  final int quantity;
  final int subtotalInCents;
}

class CheckoutAddressSection extends StatelessWidget {
  const CheckoutAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return _CheckoutSectionCard(
      title: l10n.checkoutDeliveryAddressTitle,
      child: Row(
        children: [
          Icon(
            Icons.home_outlined,
            size: AppSizes.iconMd,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.checkoutDemoAddress,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutPaymentSection extends StatelessWidget {
  const CheckoutPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return _CheckoutSectionCard(
      title: l10n.checkoutPaymentTitle,
      child: Row(
        children: [
          Icon(
            Icons.payments_outlined,
            size: AppSizes.iconMd,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.checkoutPaymentCashOnDelivery,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Icon(
            Icons.check_circle,
            size: AppSizes.iconMd,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class CheckoutSummarySection extends StatelessWidget {
  const CheckoutSummarySection({
    required this.items,
    required this.subtotalInCents,
    required this.deliveryFeeInCents,
    required this.totalInCents,
    super.key,
  });

  final List<CheckoutSummaryItem> items;
  final int subtotalInCents;
  final int deliveryFeeInCents;
  final int totalInCents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return _CheckoutSectionCard(
      title: l10n.checkoutSummaryTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items) ...[
            Row(
              children: [
                Text(
                  l10n.checkoutItemQuantity(item.quantity),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(item.name, style: theme.textTheme.bodyMedium),
                ),
                Text(
                  formatPriceInCents(context, item.subtotalInCents),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          const Divider(),
          SizedBox(height: AppSpacing.xs),
          _CheckoutAmountRow(
            label: l10n.checkoutSubtotal,
            amountInCents: subtotalInCents,
          ),
          SizedBox(height: AppSpacing.xxs),
          _CheckoutAmountRow(
            label: l10n.checkoutDeliveryFee,
            amountInCents: deliveryFeeInCents,
          ),
          SizedBox(height: AppSpacing.xs),
          _CheckoutAmountRow(
            label: l10n.checkoutTotal,
            amountInCents: totalInCents,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class CheckoutConfirmSection extends StatelessWidget {
  const CheckoutConfirmSection({
    required this.isSubmitting,
    required this.hasFailure,
    required this.onConfirm,
    super.key,
  });

  final bool isSubmitting;
  final bool hasFailure;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasFailure) ...[
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.checkoutErrorTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.checkoutErrorMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm),
        ],
        FilledButton.icon(
          onPressed: isSubmitting ? null : onConfirm,
          icon: isSubmitting
              ? SizedBox.square(
                  dimension: AppSizes.iconSm,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onSurface,
                  ),
                )
              : const Icon(Icons.check, size: AppSizes.iconMd),
          label: Text(
            isSubmitting
                ? l10n.checkoutSubmitting
                : hasFailure
                ? l10n.checkoutRetryAction
                : l10n.checkoutConfirmAction,
          ),
        ),
      ],
    );
  }
}

class CheckoutSuccessSection extends StatelessWidget {
  const CheckoutSuccessSection({
    required this.orderId,
    required this.onBackToHome,
    super.key,
  });

  final String orderId;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: AppSizes.iconLg * 2,
          color: theme.colorScheme.primary,
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          l10n.checkoutSuccessTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          l10n.checkoutSuccessMessage(orderId),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: onBackToHome,
          child: Text(l10n.checkoutSuccessBackToHome),
        ),
      ],
    );
  }
}

class _CheckoutSectionCard extends StatelessWidget {
  const _CheckoutSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _CheckoutAmountRow extends StatelessWidget {
  const _CheckoutAmountRow({
    required this.label,
    required this.amountInCents,
    this.emphasized = false,
  });

  final String label;
  final int amountInCents;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = emphasized
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          );
    final amountStyle = emphasized
        ? theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          )
        : theme.textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(formatPriceInCents(context, amountInCents), style: amountStyle),
      ],
    );
  }
}
