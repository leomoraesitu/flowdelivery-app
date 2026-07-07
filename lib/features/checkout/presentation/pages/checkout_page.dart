import 'package:flowdelivery_app/app/theme/app_tokens.dart';
import 'package:flowdelivery_app/features/cart/presentation/providers/cart_providers.dart';
import 'package:flowdelivery_app/features/checkout/domain/entities/order_draft.dart';
import 'package:flowdelivery_app/features/checkout/presentation/providers/checkout_providers.dart';
import 'package:flowdelivery_app/features/checkout/presentation/viewmodels/checkout_view_model.dart';
import 'package:flowdelivery_app/features/checkout/presentation/widgets/checkout_sections.dart';
import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({this.onBackToHome, super.key});

  final VoidCallback? onBackToHome;

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    // Returns a stale success/failure state to idle when the page is opened
    // again for a new order.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(checkoutViewModelProvider.notifier).reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutViewModelProvider);
    final cart = ref.watch(cartProvider);
    final l10n = AppLocalizations.of(context);

    final deliveryFeeInCents = cart.isEmpty
        ? 0
        : OrderDraft.standardDeliveryFeeInCents;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.contentMaxWidthMd,
              ),
              child: switch (checkoutState) {
                CheckoutSuccess(order: final order) => Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: CheckoutSuccessSection(
                    orderId: order.id,
                    onBackToHome:
                        widget.onBackToHome ??
                        () => Navigator.of(context).maybePop(),
                  ),
                ),
                _ => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CheckoutAddressSection(),
                    SizedBox(height: AppSpacing.lg),
                    const CheckoutPaymentSection(),
                    SizedBox(height: AppSpacing.lg),
                    CheckoutSummarySection(
                      items: [
                        for (final item in cart.items)
                          CheckoutSummaryItem(
                            name: item.name,
                            quantity: item.quantity,
                            subtotalInCents: item.subtotalInCents,
                          ),
                      ],
                      subtotalInCents: cart.totalInCents,
                      deliveryFeeInCents: deliveryFeeInCents,
                      totalInCents: cart.totalInCents + deliveryFeeInCents,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    CheckoutConfirmSection(
                      isSubmitting: checkoutState is CheckoutSubmitting,
                      hasFailure: checkoutState is CheckoutFailure,
                      onConfirm: cart.isEmpty
                          ? null
                          : () => ref
                                .read(checkoutViewModelProvider.notifier)
                                .placeOrder(
                                  deliveryAddress: l10n.checkoutDemoAddress,
                                ),
                    ),
                  ],
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
