import 'package:flowdelivery_app/shared/presentation/widgets/app_media_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppMediaImage', () {
    testWidgets('renders a local asset with the requested layout', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _TestApp(
          child: AppMediaImage(
            source: 'assets/images/branding/logo-flowdelivery-light.png',
            fit: BoxFit.cover,
            width: 120,
            height: 80,
            fallbackIcon: Icons.storefront_outlined,
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));

      expect(image.image, isA<AssetImage>());
      expect((image.image as AssetImage).assetName, contains('assets/images/'));
      expect(image.fit, BoxFit.cover);
      expect(image.excludeFromSemantics, isTrue);
      expect(tester.getSize(find.byType(AppMediaImage)), const Size(120, 80));
    });

    testWidgets('renders an HTTP image with an optional semantic label', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _TestApp(
          child: AppMediaImage(
            source: 'https://example.com/product.webp',
            semanticLabel: 'Foto do produto',
            fallbackIcon: Icons.fastfood_outlined,
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));

      expect(image.image, isA<NetworkImage>());
      expect(
        (image.image as NetworkImage).url,
        'https://example.com/product.webp',
      );
      expect(image.semanticLabel, 'Foto do produto');
      expect(image.excludeFromSemantics, isFalse);
    });

    testWidgets('uses the configured placeholder while remote media loads', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _TestApp(
          child: AppMediaImage(
            source: 'https://example.com/restaurant.webp',
            fallbackIcon: Icons.storefront_outlined,
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      final context = tester.element(find.byType(Image));
      final placeholder = image.loadingBuilder!(
        context,
        const SizedBox(),
        const ImageChunkEvent(cumulativeBytesLoaded: 1, expectedTotalBytes: 2),
      );

      await tester.pumpWidget(_TestApp(child: placeholder));

      final contextAfterPump = tester.element(
        find.byIcon(Icons.storefront_outlined),
      );
      final fallbackColor = Theme.of(
        contextAfterPump,
      ).colorScheme.surfaceContainerHighest;

      expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == fallbackColor,
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses the configured fallback when media fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        const _TestApp(
          child: AppMediaImage(
            source: 'https://example.com/missing.webp',
            fallbackIcon: Icons.fastfood_outlined,
            fallbackIconSize: 48,
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      final context = tester.element(find.byType(Image));
      final fallback = image.errorBuilder!(
        context,
        Exception('failed'),
        StackTrace.empty,
      );

      await tester.pumpWidget(_TestApp(child: fallback));

      final contextAfterPump = tester.element(
        find.byIcon(Icons.fastfood_outlined),
      );
      final fallbackColor = Theme.of(
        contextAfterPump,
      ).colorScheme.surfaceContainerHighest;

      expect(find.byIcon(Icons.fastfood_outlined), findsOneWidget);
      expect(
        tester.widget<Icon>(find.byIcon(Icons.fastfood_outlined)).size,
        48,
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == fallbackColor,
        ),
        findsOneWidget,
      );
    });
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }
}
