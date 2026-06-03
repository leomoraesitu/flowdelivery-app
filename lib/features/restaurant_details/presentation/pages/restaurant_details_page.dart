import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/providers/restaurant_details_providers.dart';
import 'package:flowdelivery_app/features/restaurant_details/presentation/widgets/restaurant_details_sections.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailsPage extends ConsumerWidget {
  const RestaurantDetailsPage({
    required this.restaurantId,
    this.onBack,
    this.onProductSelected,
    super.key,
  });

  final String restaurantId;
  final VoidCallback? onBack;
  final ValueChanged<String>? onProductSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncViewData = ref.watch(
      restaurantDetailsViewDataProvider(restaurantId),
    );
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.contentMaxWidthMd,
              ),
              child: asyncViewData.when(
                data: (viewData) {
                  if (viewData.details.items.isEmpty) {
                    return RestaurantDetailsStateCard(
                      icon: Icons.inbox_outlined,
                      title: l10n.restaurantDetailsEmptyStateTitle,
                      message: l10n.restaurantDetailsEmptyStateMessage,
                    );
                  }

                  return RestaurantDetailsSections(
                    viewData: viewData,
                    onBack: onBack ?? () => Navigator.of(context).maybePop(),
                    onCategorySelected: ref
                        .read(
                          restaurantDetailsSelectedCategoryProvider(
                            restaurantId,
                          ).notifier,
                        )
                        .selectCategory,
                    onProductSelected: onProductSelected,
                  );
                },
                error: (error, stackTrace) {
                  return RestaurantDetailsStateCard(
                    icon: Icons.cloud_off_outlined,
                    title: l10n.restaurantDetailsErrorStateTitle,
                    message: l10n.restaurantDetailsErrorStateMessage,
                    action: FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(restaurantDetailsProvider(restaurantId));
                        ref.invalidate(
                          restaurantDetailsViewDataProvider(restaurantId),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: AppSizes.iconLg),
                      label: Text(l10n.restaurantDetailsRetryAction),
                    ),
                  );
                },
                loading: () {
                  return RestaurantDetailsLoadingState(
                    title: l10n.restaurantDetailsLoadingStateTitle,
                    message: l10n.restaurantDetailsLoadingStateMessage,
                    semanticLabel:
                        l10n.restaurantDetailsLoadingStateSemanticLabel,
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
