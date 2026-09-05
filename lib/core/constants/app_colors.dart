import 'package:flutter/material.dart';

/// Semantic, carefully designed color system.
/// Avoids aggressive neon gradients and generic AI palettes.
/// Focuses on professional slate, deep sapphire, balanced neutrals,
/// and clear functional semantic colors.
abstract final class AppColors {
  // Brand Accent Palette
  static const Color primary = Color(0xFF1D4ED8); // Deep vibrant sapphire
  static const Color primaryDark = Color(0xFF3B82F6); // Soft luminous sapphire for dark surfaces
  static const Color primaryLight = Color(0xFFEFF6FF); // Light sapphire tint
  static const Color primaryHover = Color(0xFF1E40AF);

  // Light Theme Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSubtleLight = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderSubtleLight = Color(0xFFF1F5F9);
  static const Color borderFocusedLight = Color(0xFF1D4ED8);

  // Light Theme Typography
  static const Color textPrimaryLight = Color(0xFF0F172A); // High-contrast slate
  static const Color textSecondaryLight = Color(0xFF475569); // Muted slate
  static const Color textTertiaryLight = Color(0xFF94A3B8); // Subtle hint
  static const Color textInverseLight = Color(0xFFFFFFFF);

  // Dark Theme Neutrals
  static const Color backgroundDark = Color(0xFF0B0F17); // Obsidian / slate
  static const Color surfaceDark = Color(0xFF151D2A); // Elevated slate
  static const Color surfaceSubtleDark = Color(0xFF1E293B);
  static const Color borderDark = Color(0xFF263346);
  static const Color borderSubtleDark = Color(0xFF1A2433);
  static const Color borderFocusedDark = Color(0xFF3B82F6);

  // Dark Theme Typography
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);
  static const Color textInverseDark = Color(0xFF0F172A);

  // Semantic Status Colors (accessible contrast across both modes)
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFECACA);
  static const Color errorDark = Color(0xFFF87171);

  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color successBorder = Color(0xFFBBF7D0);
  static const Color successDark = Color(0xFF4ADE80);

  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningDark = Color(0xFFFBBF24);

  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFF0F9FF);
  static const Color infoDark = Color(0xFF38BDF8);

  // Disabled States
  static const Color disabledBackgroundLight = Color(0xFFE2E8F0);
  static const Color disabledTextLight = Color(0xFF94A3B8);
  static const Color disabledBackgroundDark = Color(0xFF1E293B);
  static const Color disabledTextDark = Color(0xFF475569);
}
