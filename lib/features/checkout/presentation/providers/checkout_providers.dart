import 'package:flowdelivery_app/features/checkout/presentation/viewmodels/checkout_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkoutViewModelProvider =
    NotifierProvider<CheckoutViewModel, CheckoutState>(CheckoutViewModel.new);
