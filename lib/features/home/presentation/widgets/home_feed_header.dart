import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeFeedHeader extends StatefulWidget {
  const HomeFeedHeader({
    required this.deliveryAddress,
    required this.logoAssetPath,
    required this.searchQuery,
    required this.onSearchChanged,
    super.key,
  });

  final String deliveryAddress;
  final String logoAssetPath;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  @override
  State<HomeFeedHeader> createState() => _HomeFeedHeaderState();
}

class _HomeFeedHeaderState extends State<HomeFeedHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant HomeFeedHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_searchController.text != widget.searchQuery) {
      _searchController.value = TextEditingValue(
        text: widget.searchQuery,
        selection: TextSelection.collapsed(offset: widget.searchQuery.length),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  widget.logoAssetPath,
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
                    l10n.homeDeliveryAddressValue(widget.deliveryAddress),
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
          controller: _searchController,
          onChanged: widget.onSearchChanged,
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
