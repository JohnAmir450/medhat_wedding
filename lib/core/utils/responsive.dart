import 'package:flutter/widgets.dart';

/// Simple, dependency-free responsive breakpoint helpers.
/// (The `responsive_framework` package in pubspec can be wired in at the
/// MaterialApp level for auto-scaling; these helpers cover per-widget
/// layout decisions like column counts and paddings.)
class Responsive {
  Responsive._();

  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  /// Horizontal page padding that grows with viewport width.
  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < mobileMax) return 20;
    if (w < tabletMax) return 48;
    return (w - 1100).clamp(64, 400) / 2 + 64;
  }

  /// Clamp content to a comfortable max reading/section width.
  static double contentMaxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w < tabletMax ? w : 1100;
  }
}
