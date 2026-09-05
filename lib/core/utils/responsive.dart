import 'package:flutter/material.dart';

/// Clean utility helpers for responsive layout across small, standard, and large screens.
abstract final class Responsive {
  static const double mobileSmallBreakpoint = 360.0;
  static const double mobileStandardBreakpoint = 414.0;
  static const double tabletBreakpoint = 600.0;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileSmallBreakpoint;
  }

  static bool isTabletOrLarger(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobileSmallBreakpoint) return 16.0;
    if (width >= tabletBreakpoint) return 32.0;
    return 24.0;
  }
}
