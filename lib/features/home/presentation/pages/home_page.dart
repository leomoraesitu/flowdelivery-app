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
    final content = ref.watch(homeFeedProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      bottomNavigationBar: _HomeBottomNavigationBar(l10n: l10n),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 720
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
                    maxWidth: _desktopContentMaxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeFeedHeader(
                        deliveryAddress: content.deliveryAddress,
                        logoAssetPath: content.promotion.imageAssetPath,
                      ),
                      SizedBox(height: AppSpacing.xl),
                      HomeFeedSections(
                        content: content,
                        availableWidth: constraints.maxWidth,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
