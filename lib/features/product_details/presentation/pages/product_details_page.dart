import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/product_details/presentation/providers/product_details_providers.dart';
import 'package:flowdelivery_app/features/product_details/presentation/widgets/product_details_sections.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailsPage extends ConsumerWidget {
  const ProductDetailsPage({required this.productId, this.onBack, super.key});

  final String productId;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProduct = ref.watch(productDetailsProvider(productId));
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
              child: asyncProduct.when(
                data: (product) {
                  if (product == null) {
                    return ProductDetailsStateCard(
                      icon: Icons.search_off_outlined,
                      title: l10n.productDetailsNotFoundStateTitle,
                      message: l10n.productDetailsNotFoundStateMessage,
                      action: OutlinedButton.icon(
                        onPressed:
                            onBack ?? () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: AppSizes.iconLg,
                        ),
                        label: Text(l10n.productDetailsBackAction),
                      ),
                    );
                  }

                  return ProductDetailsSections(
                    product: product,
                    onBack: onBack ?? () => Navigator.of(context).maybePop(),
                  );
                },
                error: (error, stackTrace) {
                  return ProductDetailsStateCard(
                    icon: Icons.cloud_off_outlined,
                    title: l10n.productDetailsErrorStateTitle,
                    message: l10n.productDetailsErrorStateMessage,
                    action: FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(productDetailsProvider(productId));
                      },
                      icon: const Icon(Icons.refresh, size: AppSizes.iconLg),
                      label: Text(l10n.productDetailsRetryAction),
                    ),
                  );
                },
                loading: () {
                  return ProductDetailsLoadingState(
                    title: l10n.productDetailsLoadingStateTitle,
                    message: l10n.productDetailsLoadingStateMessage,
                    semanticLabel: l10n.productDetailsLoadingStateSemanticLabel,
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
