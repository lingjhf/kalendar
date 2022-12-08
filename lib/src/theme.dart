import 'dart:ui';

import 'package:flutter/material.dart';

class KalendarStyle extends ThemeExtension<KalendarStyle> {
  KalendarStyle({
    double? width,
    double? height,
    Color? backgroundColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? accentBackgroundColor,
    double? toolbarHeight,
    double? weekBarHeight,
    TextStyle? weekTextStyle,
  })  : width = width ?? 7 * 36,
        height = height ?? 2 * 32 + 6 * 36,
        backgroundColor = backgroundColor ?? const Color(0xffffffff),
        padding = padding ?? const EdgeInsets.all(16),
        borderRadius = borderRadius ?? BorderRadius.circular(16),
        primaryColor = primaryColor ?? const Color(0xff000000),
        secondaryColor =
            secondaryColor ?? const Color(0xff3C3C43).withOpacity(0.3),
        accentColor = accentColor ?? const Color(0xff0084FF),
        accentBackgroundColor =
            accentBackgroundColor ?? const Color(0xff0084FF).withOpacity(0.3),
        toolbarHeight = toolbarHeight ?? 32,
        weekBarHeight = weekBarHeight ?? 32,
        weekTextStyle = weekTextStyle ??
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  final double width;

  final double height;

  //背景颜色
  final Color backgroundColor;

  //内间距
  final EdgeInsets padding;

  //圆角
  final BorderRadius borderRadius;

  final Color primaryColor;

  final Color secondaryColor;

  final Color accentColor;

  final Color accentBackgroundColor;

  final double toolbarHeight;

  final double weekBarHeight;

  final TextStyle weekTextStyle;

  //暗黑风格
  factory KalendarStyle.dark() => KalendarStyle(
      backgroundColor: const Color(0xff000000),
      primaryColor: const Color(0xffffffff),
      secondaryColor: const Color(0xffEBEBF5).withOpacity(0.3));

  @override
  KalendarStyle copyWith({
    double? width,
    double? height,
    Color? backgroundColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Color? accentBackgroundColor,
    double? toolbarHeight,
    double? weekBarHeight,
    TextStyle? weekTextStyle,
  }) {
    return KalendarStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      accentBackgroundColor:
          accentBackgroundColor ?? this.accentBackgroundColor,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      weekBarHeight: weekBarHeight ?? this.weekBarHeight,
      weekTextStyle: weekTextStyle ?? this.weekTextStyle,
    );
  }

  @override
  KalendarStyle lerp(ThemeExtension<KalendarStyle>? other, double t) {
    if (other is! KalendarStyle) return this;
    return KalendarStyle(
      width: lerpDouble(width, other.width, t),
      height: lerpDouble(height, other.height, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      padding: EdgeInsets.lerp(padding, other.padding, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
      accentColor: Color.lerp(accentColor, other.accentColor, t),
      accentBackgroundColor:
          Color.lerp(accentBackgroundColor, other.accentBackgroundColor, t),
      toolbarHeight: lerpDouble(toolbarHeight, other.toolbarHeight, t),
      weekBarHeight: lerpDouble(weekBarHeight, other.weekBarHeight, t),
      weekTextStyle: TextStyle.lerp(weekTextStyle, other.weekTextStyle, t),
    );
  }
}
