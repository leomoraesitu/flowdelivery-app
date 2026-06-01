import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_category.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_promotion.dart';
import 'package:flowdelivery_app/features/home/domain/entities/home_restaurant.dart';
import 'package:flowdelivery_app/features/home/presentation/providers/home_feed_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeFeedSections extends StatelessWidget {
  const HomeFeedSections({
    required this.viewData,
    required this.availableWidth,
    required this.onCategorySelected,
    super.key,
  });

  final HomeFeedViewData viewData;
  final double availableWidth;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CategoryScroller(
          categories: viewData.categories,
          selectedCategoryId: viewData.discoveryState.selectedCategoryId,
          onCategorySelected: onCategorySelected,
        ),
        SizedBox(height: AppSpacing.xl),
        _PromotionBanner(
          promotion: viewData.promotion,
          showArtwork: availableWidth >= 520,
        ),
        SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.homeFeaturedSectionTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: () {}, child: Text(l10n.homeSeeAllAction)),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        _RestaurantGrid(restaurants: viewData.visibleRestaurants),
      ],
    );
  }
}

class _CategoryScroller extends StatelessWidget {
  const _CategoryScroller({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<HomeCategory> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < categories.length; index++) ...[
            ChoiceChip(
              label: Text(_labelForCategory(context, categories[index])),
              selected: categories[index].id == selectedCategoryId,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(categories[index].id);
                }
              },
              labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: categories[index].id == selectedCategoryId
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: colorScheme.surfaceContainerLow,
              selectedColor: colorScheme.primaryContainer,
              side: BorderSide(
                color: categories[index].id == selectedCategoryId
                    ? colorScheme.primaryContainer
                    : colorScheme.outlineVariant,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
            ),
            if (index != categories.length - 1) SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  String _labelForCategory(BuildContext context, HomeCategory category) {
    final l10n = AppLocalizations.of(context);

    return switch (category.id) {
      'all' => l10n.homeCategoryAll,
      'burgers' => l10n.homeCategoryBurgers,
      'pizza' => l10n.homeCategoryPizza,
      'sushi' => l10n.homeCategorySushi,
      'healthy' => l10n.homeCategoryHealthy,
      _ => throw StateError('Unsupported home category id: ${category.id}'),
    };
  }
}

class _PromotionBanner extends StatelessWidget {
  const _PromotionBanner({required this.promotion, required this.showArtwork});

  final HomePromotion promotion;
  final bool showArtwork;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeBannerTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _BannerPill(
                      label: l10n.homeBannerDiscountValue(
                        promotion.discountPercentage,
                      ),
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.primary,
                    ),
                    if (promotion.hasFreeDelivery)
                      _BannerPill(
                        label: l10n.homeBannerFreeDeliveryBadge,
                        backgroundColor: colorScheme.tertiaryContainer,
                        foregroundColor: colorScheme.onTertiaryContainer,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (showArtwork) ...[
            SizedBox(width: AppSpacing.lg),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              padding: EdgeInsets.all(AppSpacing.md),
              child: ExcludeSemantics(
                child: Image.asset(
                  promotion.imageAssetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.local_offer_outlined,
                      color: colorScheme.primary,
                      size: AppSizes.iconLg,
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BannerPill extends StatelessWidget {
  const _BannerPill({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RestaurantGrid extends StatelessWidget {
  const _RestaurantGrid({required this.restaurants});

  final List<HomeRestaurant> restaurants;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restaurants.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisExtent: 240,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemBuilder: (context, index) {
        return _RestaurantCard(restaurant: restaurants[index]);
      },
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant});

  final HomeRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: colorScheme.surfaceContainerHighest,
              padding: EdgeInsets.all(AppSpacing.xl),
              child: ExcludeSemantics(
                child: Image.asset(
                  restaurant.imageAssetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.storefront_outlined,
                      color: colorScheme.primary,
                      size: AppSizes.iconLg,
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.homeRestaurantRatingAndDelivery(
                    restaurant.rating,
                    restaurant.deliveryTimeMinMinutes,
                    restaurant.deliveryTimeMaxMinutes,
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
