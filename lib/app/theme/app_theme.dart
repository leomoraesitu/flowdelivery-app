import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tokens.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppLightColors.primary,
      onPrimary: AppLightColors.onPrimary,
      primaryContainer: AppLightColors.primaryContainer,
      onPrimaryContainer: AppLightColors.onPrimaryContainer,
      secondary: AppLightColors.secondary,
      onSecondary: AppLightColors.onSecondary,
      secondaryContainer: AppLightColors.secondaryContainer,
      onSecondaryContainer: AppLightColors.onSecondaryContainer,
      tertiary: AppLightColors.accent,
      onTertiary: AppLightColors.onAccent,
      tertiaryContainer: AppLightColors.accentContainer,
      onTertiaryContainer: AppLightColors.onAccentContainer,
      error: AppLightColors.error,
      onError: AppLightColors.onError,
      surface: AppLightColors.surface,
      onSurface: AppLightColors.onSurface,
      outline: AppLightColors.outline,
      outlineVariant: AppLightColors.divider,
    );

    return _buildTheme(
      colorScheme,
      scaffoldBackgroundColor: AppLightColors.background,
      cardColor: AppLightColors.secondaryBackground,
    );
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppDarkColors.primary,
      onPrimary: AppDarkColors.onPrimary,
      primaryContainer: AppDarkColors.primaryContainer,
      onPrimaryContainer: AppDarkColors.onPrimaryContainer,
      secondary: AppDarkColors.secondary,
      onSecondary: AppDarkColors.onSecondary,
      secondaryContainer: AppDarkColors.secondaryContainer,
      onSecondaryContainer: AppDarkColors.onSecondaryContainer,
      tertiary: AppDarkColors.accent,
      onTertiary: AppDarkColors.onAccent,
      tertiaryContainer: AppDarkColors.accentContainer,
      onTertiaryContainer: AppDarkColors.onAccentContainer,
      error: AppDarkColors.error,
      onError: AppDarkColors.onError,
      surface: AppDarkColors.surface,
      onSurface: AppDarkColors.onSurface,
      outline: AppDarkColors.outline,
      outlineVariant: AppDarkColors.divider,
    );

    return _buildTheme(
      colorScheme,
      scaffoldBackgroundColor: AppDarkColors.background,
      cardColor: AppDarkColors.secondaryBackground,
    );
  }

  static ThemeData _buildTheme(
    ColorScheme colorScheme, {
    Color? scaffoldBackgroundColor,
    Color? cardColor,
  }) {
    final textTheme = _buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppFonts.primary,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: scaffoldBackgroundColor ?? colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor ?? colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final baseTheme = Typography.material2021().black;
    final primaryTextTheme = baseTheme.apply(fontFamily: AppFonts.primary);

    return primaryTextTheme
        .apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        )
        .copyWith(
          bodyMedium: primaryTextTheme.bodyMedium?.copyWith(
            fontFamily: AppFonts.secondary,
          ),
          bodySmall: primaryTextTheme.bodySmall?.copyWith(
            fontFamily: AppFonts.secondary,
          ),
          labelSmall: primaryTextTheme.labelSmall?.copyWith(
            fontFamily: AppFonts.mono,
          ),
        );
  }
}
