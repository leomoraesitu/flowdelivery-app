import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/home/presentation/providers/home_feed_providers.dart';
import 'package:flowdelivery_app/features/home/presentation/widgets/home_feed_header.dart';
import 'package:flowdelivery_app/features/home/presentation/widgets/home_feed_sections.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const double _desktopContentMaxWidth = 880;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncContent = ref.watch(homeFeedAsyncProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      bottomNavigationBar: _HomeBottomNavigationBar(l10n: l10n),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _HomePageFrame(
              availableWidth: constraints.maxWidth,
              child: asyncContent.when(
                data: (content) {
                  final viewData = ref.watch(homeFeedViewProvider);

                  if (content.featuredRestaurants.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeFeedHeader(
                          deliveryAddress: viewData.deliveryAddress,
                          logoAssetPath: viewData.promotion.imageAssetPath,
                          searchQuery: viewData.discoveryState.searchQuery,
                          onSearchChanged: ref
                              .read(homeFeedDiscoveryControllerProvider.notifier)
                              .setSearchQuery,
                        ),
                        SizedBox(height: AppSpacing.xl),
                        _HomeFeedStateCard(
                          icon: Icons.inbox_outlined,
                          title: l10n.homeEmptyStateTitle,
                          message: l10n.homeEmptyStateMessage,
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeFeedHeader(
                        deliveryAddress: viewData.deliveryAddress,
                        logoAssetPath: viewData.promotion.imageAssetPath,
                        searchQuery: viewData.discoveryState.searchQuery,
                        onSearchChanged: ref
                            .read(homeFeedDiscoveryControllerProvider.notifier)
                            .setSearchQuery,
                      ),
                      SizedBox(height: AppSpacing.xl),
                      HomeFeedSections(
                        viewData: viewData,
                        availableWidth: constraints.maxWidth,
                        onCategorySelected: ref
                            .read(homeFeedDiscoveryControllerProvider.notifier)
                            .selectCategory,
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  return _HomeFeedStateCard(
                    icon: Icons.cloud_off_outlined,
                    title: l10n.homeErrorStateTitle,
                    message: l10n.homeErrorStateMessage,
                    action: FilledButton.icon(
                      onPressed: () => ref.invalidate(homeFeedAsyncProvider),
                      icon: const Icon(Icons.refresh, size: AppSizes.iconLg),
                      label: Text(l10n.homeRetryAction),
                    ),
                  );
                },
                loading: () {
                  return _HomeFeedLoadingState(
                    title: l10n.homeLoadingStateTitle,
                    message: l10n.homeLoadingStateMessage,
                    semanticLabel: l10n.homeLoadingStateSemanticLabel,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomePageFrame extends StatelessWidget {
  const _HomePageFrame({required this.availableWidth, required this.child});

  final double availableWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = availableWidth >= 720
        ? AppSpacing.xl
        : AppSpacing.md;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        AppSpacing.lg,
        horizontalPadding,
        AppSpacing.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: HomePage._desktopContentMaxWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _HomeFeedLoadingState extends StatelessWidget {
  const _HomeFeedLoadingState({
    required this.title,
    required this.message,
    required this.semanticLabel,
  });

  final String title;
  final String message;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Semantics(
            label: semanticLabel,
            liveRegion: true,
            child: SizedBox.square(
              dimension: AppSizes.touchTarget,
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3,
              ),
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
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeFeedStateCard extends StatelessWidget {
  const _HomeFeedStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
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
          if (action != null) ...[
            SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}

class _HomeBottomNavigationBar extends StatelessWidget {
  const _HomeBottomNavigationBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined, size: AppSizes.iconLg),
          selectedIcon: const Icon(Icons.home, size: AppSizes.iconLg),
          label: l10n.homeBottomNavHome,
        ),
        NavigationDestination(
          icon: const Icon(Icons.explore_outlined, size: AppSizes.iconLg),
          selectedIcon: const Icon(Icons.explore, size: AppSizes.iconLg),
          label: l10n.homeBottomNavBrowse,
        ),
        NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined, size: AppSizes.iconLg),
          selectedIcon: const Icon(Icons.receipt_long, size: AppSizes.iconLg),
          label: l10n.homeBottomNavOrders,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline, size: AppSizes.iconLg),
          selectedIcon: const Icon(Icons.person, size: AppSizes.iconLg),
          label: l10n.homeBottomNavAccount,
        ),
      ],
    );
  }
}
