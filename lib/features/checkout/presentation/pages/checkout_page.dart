import 'package:flowdelivery_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Checkout page skeleton registered with the protected `/checkout` route.
/// The order summary, payment, address, and submission states land in the
/// next approved task.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: const SafeArea(child: SizedBox.shrink()),
    );
  }
}
