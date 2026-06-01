import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeFeedHeader extends StatelessWidget {
  const HomeFeedHeader({
    required this.deliveryAddress,
    required this.logoAssetPath,
    super.key,
  });

  final String deliveryAddress;
  final String logoAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: AppSizes.touchTarget,
              height: AppSizes.touchTarget,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              alignment: Alignment.center,
              child: ExcludeSemantics(
                child: Image.asset(
                  logoAssetPath,
                  width: AppSizes.iconLg,
                  height: AppSizes.iconLg,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.local_shipping_outlined,
                      color: colorScheme.primary,
                      size: AppSizes.iconLg,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeDeliveryAddressLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs / 2),
                  Text(
                    l10n.homeDeliveryAddressValue(deliveryAddress),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: AppSizes.touchTarget,
              height: AppSizes.touchTarget,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: colorScheme.primary,
                size: AppSizes.iconLg,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: l10n.homeSearchHint,
            prefixIcon: const Icon(Icons.search, size: AppSizes.iconLg),
            suffixIcon: const Icon(Icons.tune, size: AppSizes.iconLg),
            filled: true,
            fillColor: colorScheme.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ],
    );
  }
}
