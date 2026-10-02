import 'package:flutter/material.dart';

class FrozenFoodThemeExtension extends ThemeExtension<FrozenFoodThemeExtension> {
  final Color coldChainColor;
  final Color coldChainMutedColor;
  final Color dryIceColor;
  final Color dryIceMutedColor;
  final Color flashDealColor;
  final Color flashDealMutedColor;
  final Color inStockColor;
  final Color lowStockColor;
  final Color outOfStockColor;

  const FrozenFoodThemeExtension({
    required this.coldChainColor,
    required this.coldChainMutedColor,
    required this.dryIceColor,
    required this.dryIceMutedColor,
    required this.flashDealColor,
    required this.flashDealMutedColor,
    required this.inStockColor,
    required this.lowStockColor,
    required this.outOfStockColor,
  });

  @override
  ThemeExtension<FrozenFoodThemeExtension> copyWith({
    Color? coldChainColor,
    Color? coldChainMutedColor,
    Color? dryIceColor,
    Color? dryIceMutedColor,
    Color? flashDealColor,
    Color? flashDealMutedColor,
    Color? inStockColor,
    Color? lowStockColor,
    Color? outOfStockColor,
  }) {
    return FrozenFoodThemeExtension(
      coldChainColor: coldChainColor ?? this.coldChainColor,
      coldChainMutedColor: coldChainMutedColor ?? this.coldChainMutedColor,
      dryIceColor: dryIceColor ?? this.dryIceColor,
      dryIceMutedColor: dryIceMutedColor ?? this.dryIceMutedColor,
      flashDealColor: flashDealColor ?? this.flashDealColor,
      flashDealMutedColor: flashDealMutedColor ?? this.flashDealMutedColor,
      inStockColor: inStockColor ?? this.inStockColor,
      lowStockColor: lowStockColor ?? this.lowStockColor,
      outOfStockColor: outOfStockColor ?? this.outOfStockColor,
    );
  }

  @override
  ThemeExtension<FrozenFoodThemeExtension> lerp(
      ThemeExtension<FrozenFoodThemeExtension>? other, double t) {
    if (other is! FrozenFoodThemeExtension) return this;
    return FrozenFoodThemeExtension(
      coldChainColor: Color.lerp(coldChainColor, other.coldChainColor, t)!,
      coldChainMutedColor: Color.lerp(coldChainMutedColor, other.coldChainMutedColor, t)!,
      dryIceColor: Color.lerp(dryIceColor, other.dryIceColor, t)!,
      dryIceMutedColor: Color.lerp(dryIceMutedColor, other.dryIceMutedColor, t)!,
      flashDealColor: Color.lerp(flashDealColor, other.flashDealColor, t)!,
      flashDealMutedColor: Color.lerp(flashDealMutedColor, other.flashDealMutedColor, t)!,
      inStockColor: Color.lerp(inStockColor, other.inStockColor, t)!,
      lowStockColor: Color.lerp(lowStockColor, other.lowStockColor, t)!,
      outOfStockColor: Color.lerp(outOfStockColor, other.outOfStockColor, t)!,
    );
  }
}
