import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'di/app_providers.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class FlowDeliveryApp extends StatelessWidget {
  const FlowDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: appProviderOverrides,
      child: const FlowDeliveryAppView(),
    );
  }
}

class FlowDeliveryAppView extends ConsumerWidget {
  const FlowDeliveryAppView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(appRouterProvider),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    );
  }
}
