import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formats an integer amount in cents as locale-aware currency copy.
String formatPriceInCents(BuildContext context, int priceInCents) {
  final price = priceInCents / 100;
  return NumberFormat.simpleCurrency(
    locale: Localizations.localeOf(context).toLanguageTag(),
  ).format(price);
}
