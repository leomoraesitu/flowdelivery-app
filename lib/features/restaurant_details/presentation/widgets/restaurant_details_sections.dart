import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_category.dart';
import 'package:flowdelivery_app/features/restaurant_details/domain/entities/restaurant_menu_item.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/providers/restaurant_details_providers.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flowdelivery_app/shared/presentation/widgets/app_media_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RestaurantDetailsSections extends StatelessWidget {
  const RestaurantDetailsSections({
    required this.viewData,
    required this.onBack,
    required this.onCategorySelected,
    this.onProductSelected,
    super.key,
  });

  final RestaurantDetailsViewData viewData;
  final VoidCallback onBack;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String>? onProductSelected;

  @override
  Widget build(BuildContext context) {
    final details = viewData.details;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RestaurantHeader(
          imageAssetPath: details.imageAssetPath,
          onBack: onBack,
        ),
        SizedBox(height: AppSpacing.lg),
        Text(
          details.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          l10n.restaurantDetailsRatingAndDelivery(
            details.rating,
            details.deliveryTimeMinMinutes,
            details.deliveryTimeMaxMinutes,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.xl),
        Semantics(
          label: l10n.restaurantDetailsMenuSemanticLabel(details.name),
          child: Text(
            l10n.restaurantDetailsMenuSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _CategoryScroller(
          categories: details.categories,
          selectedCategoryId: viewData.selectedCategoryId,
          onCategorySelected: onCategorySelected,
        ),
        SizedBox(height: AppSpacing.lg),
        _MenuItemList(
          items: viewData.visibleItems,
          onProductSelected: onProductSelected,
        ),
      ],
    );
  }
}

class RestaurantDetailsStateCard extends StatelessWidget {
  const RestaurantDetailsStateCard({
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

class RestaurantDetailsLoadingState extends StatelessWidget {
  const RestaurantDetailsLoadingState({
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

class _RestaurantHeader extends StatelessWidget {
  const _RestaurantHeader({required this.imageAssetPath, required this.onBack});

  final String imageAssetPath;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: AppSizes.restaurantHeroHeight,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          padding: EdgeInsets.all(AppSpacing.xl),
          child: ExcludeSemantics(
            child: AppMediaImage(
              source: imageAssetPath,
              fit: BoxFit.contain,
              fallbackIcon: Icons.storefront_outlined,
              fallbackIconSize: AppSizes.touchTarget,
            ),
          ),
        ),
        Positioned(
          left: AppSpacing.md,
          top: AppSpacing.md,
          child: IconButton.filledTonal(
            onPressed: onBack,
            tooltip: l10n.restaurantDetailsBackAction,
            icon: const Icon(Icons.arrow_back),
          ),
        ),
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

  final List<RestaurantMenuCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < categories.length; index++) ...[
            Builder(
              builder: (context) {
                final category = categories[index];
                final label = _labelForCategory(context, category);
                final isSelected = category.id == selectedCategoryId;

                return Semantics(
                  label: AppLocalizations.of(
                    context,
                  ).restaurantDetailsCategoryFilterSemanticLabel(label),
                  selected: isSelected,
                  child: ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        onCategorySelected(category.id);
                      }
                    },
                    backgroundColor: colorScheme.surfaceContainerLow,
                    selectedColor: colorScheme.primaryContainer,
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : colorScheme.outlineVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                );
              },
            ),
            if (index != categories.length - 1) SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  String _labelForCategory(
    BuildContext context,
    RestaurantMenuCategory category,
  ) {
    final l10n = AppLocalizations.of(context);

    return switch (category.id) {
      'popular' => l10n.restaurantDetailsCategoryPopular,
      'burgers' => l10n.restaurantDetailsCategoryBurgers,
      'sides' => l10n.restaurantDetailsCategorySides,
      'drinks' => l10n.restaurantDetailsCategoryDrinks,
      _ => throw StateError(
        'Unsupported restaurant-details category id: ${category.id}',
      ),
    };
  }
}

class _MenuItemList extends StatelessWidget {
  const _MenuItemList({required this.items, this.onProductSelected});

  final List<RestaurantMenuItem> items;
  final ValueChanged<String>? onProductSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => _MenuItemCard(
        item: items[index],
        onProductSelected: onProductSelected,
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({required this.item, this.onProductSelected});

  final RestaurantMenuItem item;
  final ValueChanged<String>? onProductSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onProductSelected = this.onProductSelected;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onProductSelected == null
            ? null
            : () => onProductSelected(item.id),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      _formatPrice(context, item.priceInCents),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: SizedBox.square(
                  dimension: AppSizes.menuItemThumbnail,
                  child: AppMediaImage(
                    source: item.imageAssetPath,
                    fit: BoxFit.cover,
                    fallbackIcon: Icons.fastfood_outlined,
                    fallbackIconSize: AppSizes.iconLg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(BuildContext context, int priceInCents) {
    final price = priceInCents / 100;
    return NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toLanguageTag(),
    ).format(price);
  }
}
