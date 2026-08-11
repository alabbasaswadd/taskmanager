import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? height;
  final String? fontFamily;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? wordSpacing;
  final Paint? foreground;
  final Paint? background;
  final List<Shadow>? shadows;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final bool? softWrap;
  final double? textScaleFactor;
  final double? horizontalPadding;

  const AppText(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.height,
    this.fontFamily,
    this.maxLines,
    this.overflow,
    this.style,
    this.decoration,
    this.letterSpacing,
    this.wordSpacing,
    this.foreground,
    this.background,
    this.shadows,
    this.locale,
    this.strutStyle,
    this.softWrap,
    this.textScaleFactor,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      overflow: overflow ?? TextOverflow.ellipsis,
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: fontSize ?? 16,
      height: height ?? 1.5,
      fontFamily: fontFamily ?? "Cairo-Bold",
      decoration: decoration,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      foreground: foreground,
      background: background,
      shadows: shadows,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0),
      child: Text(
        text,
        key: key,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines ?? 1,
        overflow: overflow,
        locale: locale,
        strutStyle: strutStyle,
        softWrap: softWrap,
        textScaleFactor: textScaleFactor,
        style: (style ?? defaultStyle).copyWith(
          color: color ?? style?.color ?? defaultStyle.color,
          fontWeight:
              fontWeight ?? style?.fontWeight ?? defaultStyle.fontWeight,
          fontSize: fontSize ?? style?.fontSize ?? defaultStyle.fontSize,
          height: height ?? style?.height ?? defaultStyle.height,
          fontFamily:
              fontFamily ?? style?.fontFamily ?? defaultStyle.fontFamily,
        ),
      ),
    );
  }

  /// دوال ثابتة للأنماط الشائعة
  static Widget medium(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? padding,
  }) {
    return AppText(
      text,
      fontSize: 14,
      fontWeight: FontWeight.w500, // Medium
      color: color,
      textAlign: textAlign,
      horizontalPadding: padding,
    );
  }

  static Widget semiBold(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? padding,
  }) {
    return AppText(
      text,
      fontSize: 16,
      fontWeight: FontWeight.w600, // SemiBold
      color: color,
      textAlign: textAlign,
      horizontalPadding: padding,
    );
  }

  static Widget bold(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? padding,
  }) {
    return AppText(
      text,
      fontSize: 18,
      fontWeight: FontWeight.w700, // Bold
      color: color,
      textAlign: textAlign,
      horizontalPadding: padding,
    );
  }
}
