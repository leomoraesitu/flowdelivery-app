import 'package:flutter/material.dart';

class AppMediaImage extends StatelessWidget {
  const AppMediaImage({
    required this.source,
    required this.fallbackIcon,
    this.fallbackIconSize,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.semanticLabel,
    super.key,
  });

  final String source;
  final IconData fallbackIcon;
  final double? fallbackIconSize;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isRemote =
        source.startsWith('https://') || source.startsWith('http://');

    if (isRemote) {
      return Image.network(
        source,
        fit: fit,
        width: width,
        height: height,
        semanticLabel: semanticLabel,
        excludeFromSemantics: semanticLabel == null,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return _buildFallback(context);
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    }

    return Image.asset(
      source,
      fit: fit,
      width: width,
      height: height,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      errorBuilder: (context, error, stackTrace) => _buildFallback(context),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          fallbackIcon,
          color: colorScheme.primary,
          size: fallbackIconSize,
        ),
      ),
    );
  }
}
