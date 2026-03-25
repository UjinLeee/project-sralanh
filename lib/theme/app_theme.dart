import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// M3-inspired palette aligned with the original Tailwind mockup.
abstract final class AppColors {
  static const Color primary = Color(0xFF136964);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF80CBC4);
  static const Color onPrimaryContainer = Color(0xFF005652);
  static const Color secondary = Color(0xFF7B5549);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFCCBC);
  static const Color onSecondaryContainer = Color(0xFF7A5448);
  static const Color tertiaryContainer = Color(0xFFFBAA8F);
  static const Color onTertiaryContainer = Color(0xFF773C28);
  static const Color surface = Color(0xFFF3FAFF);
  static const Color surfaceContainer = Color(0xFFDBF1FE);
  static const Color surfaceContainerLow = Color(0xFFE6F6FF);
  static const Color surfaceContainerHighest = Color(0xFFCFE6F2);
  /// Aligns with mock `surface-container-high` (#d5ecf8).
  static const Color surfaceContainerHigh = Color(0xFFD5ECF8);
  static const Color onSurface = Color(0xFF071E27);
  static const Color onSurfaceVariant = Color(0xFF3F4947);
  static const Color outlineVariant = Color(0xFFBEC9C7);
  static const Color primaryFixed = Color(0xFFA4F0E9);
  static const Color secondaryFixed = Color(0xFFFFDBD0);
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.secondary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outlineVariant: AppColors.outlineVariant,
      error: Color(0xFFBA1A1A),
    ),
    scaffoldBackgroundColor: Colors.white,
  );

  final bodyFont = GoogleFonts.beVietnamProTextTheme(base.textTheme);
  final headlineFont = GoogleFonts.plusJakartaSansTextTheme(bodyFont);

  return base.copyWith(
    textTheme: headlineFont.apply(
      bodyColor: AppColors.onSurface,
      displayColor: AppColors.onSurface,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.onSurface,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E293B),
      ),
    ),
  );
}

TextStyle khmerTextStyle({
  required BuildContext context,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
}) {
  return GoogleFonts.kantumruyPro(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? Theme.of(context).colorScheme.onSurface,
    height: 1.25,
  );
}

String categoryTagLabel(String category) {
  return switch (category) {
    'greeting' => '#인사',
    'kids' => '#어린이',
    'church' => '#교회',
    _ => '#$category',
  };
}

String categoryDisplayName(String category) {
  return switch (category) {
    'greeting' => '인사',
    'kids' => '어린이',
    'church' => '교회',
    _ => category,
  };
}

IconData categoryIcon(String category) {
  return switch (category) {
    'greeting' => Icons.waving_hand_rounded,
    'kids' => Icons.child_care_rounded,
    'church' => Icons.church_outlined,
    _ => Icons.category_rounded,
  };
}
