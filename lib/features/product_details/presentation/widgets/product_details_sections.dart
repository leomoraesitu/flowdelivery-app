import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/product_details/domain/entities/product_details.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductDetailsSections extends StatelessWidget {
  const ProductDetailsSections({
    required this.product,
    required this.onBack,
    super.key,
  });

  final ProductDetails product;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final formattedPrice = _formatPrice(context, product.priceInCents);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProductHeader(
          imageAssetPath: product.imageAssetPath,
          imageSemanticLabel: l10n.productDetailsImageSemanticLabel(
            product.name,
          ),
          onBack: onBack,
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          product.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Semantics(
          label: l10n.productDetailsPriceSemanticLabel(formattedPrice),
          child: ExcludeSemantics(
            child: Text(
              formattedPrice,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          product.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _formatPrice(BuildContext context, int priceInCents) {
    final price = priceInCents / 100;
    return NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toLanguageTag(),
    ).format(price);
  }
}

class ProductDetailsStateCard extends StatelessWidget {
  const ProductDetailsStateCard({
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

class ProductDetailsLoadingState extends StatelessWidget {
  const ProductDetailsLoadingState({
    required this.title,
    required this.message,
    required this.semanticLabel,
    super.key,
  });

  final String title;
  final String message;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Semantics(
            label: semanticLabel,
            liveRegion: true,
            child: const SizedBox.square(
              dimension: AppSizes.touchTarget,
              child: CircularProgressIndicator(),
            ),
          ),
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
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({
    required this.imageAssetPath,
    required this.imageSemanticLabel,
    required this.onBack,
  });

  final String imageAssetPath;
  final String imageSemanticLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        Semantics(
          image: true,
          label: imageSemanticLabel,
          child: Container(
            width: double.infinity,
            height: AppSizes.restaurantHeroHeight,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Image.asset(
              imageAssetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.fastfood_outlined,
                  color: colorScheme.primary,
                  size: AppSizes.touchTarget,
                );
              },
            ),
          ),
        ),
        Positioned(
          left: AppSpacing.md,
          top: AppSpacing.md,
          child: IconButton.filledTonal(
            onPressed: onBack,
            tooltip: l10n.productDetailsBackAction,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      ],
    );
  }
}
