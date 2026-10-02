import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary - Deep Frozen Blue
  static const primary = Color(0xFF0A4B8C);
  static const onPrimary = Colors.white;
  static const primaryContainer = Color(0xFFD6E4FF);
  static const onPrimaryContainer = Color(0xFF001C3B);

  // Secondary - Arctic Teal
  static const secondary = Color(0xFF006877);
  static const onSecondary = Colors.white;
  static const secondaryContainer = Color(0xFFAEECF8);
  static const onSecondaryContainer = Color(0xFF001F25);

  // Tertiary - Frost Accent
  static const tertiary = Color(0xFF006E2B);
  static const onTertiary = Colors.white;
  static const tertiaryContainer = Color(0xFF97F9A6);
  static const onTertiaryContainer = Color(0xFF00210B);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const onError = Colors.white;
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF410002);

  // Surface
  static const surface = Color(0xFFF8FAFE);
  static const onSurface = Color(0xFF181C20);
  static const surfaceVariant = Color(0xFFDFE2EB);
  static const outline = Color(0xFF6F7789);

  // Domain-specific Theme Extension Colors
  static const coldChainBlue = Color(0xFF1565C0);
  static const coldChainBlueMuted = Color(0xFFE3F2FD);
  static const dryIcePurple = Color(0xFF6A1B9A);
  static const dryIcePurpleMuted = Color(0xFFF3E5F5);
  static const flashDealOrange = Color(0xFFE65100);
  static const flashDealOrangeMuted = Color(0xFFFFF3E0);
  static const inStockGreen = Color(0xFF1B5E20);
  static const lowStockAmber = Color(0xFFE65100);
  static const outOfStockRed = Color(0xFFB71C1C);
}
