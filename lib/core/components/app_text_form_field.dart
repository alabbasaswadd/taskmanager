import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.suffix,
    this.validator,
    this.icon,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.prefixIconColor,
    this.onTap,
    this.readOnly,
    this.horizontalPadding = 0.0,
    this.borderRadius = 12.0,
    this.fillColor,
    this.enabled = true,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.counterText,
    this.hintText,
    this.hintStyle,
  });

  final String label;
  final TextEditingController? controller;
  final bool? suffix;
  final bool obscureText;
  final IconButton? suffixIcon;
  final TextInputType? keyboardType;
  final IconData? icon;
  final Color? prefixIconColor;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final bool? readOnly;
  final double horizontalPadding;
  final double borderRadius;
  final Color? fillColor;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? counterText;
  final String? hintText;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final outline = Theme.of(context).colorScheme.outline;

    // Subtle fill: Slate 50 in light, Slate 800 in dark
    final defaultFill = fillColor ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC));

    // Border colors derived from theme
    final enabledBorderColor = outline.withValues(alpha: isDark ? 0.25 : 0.35);
    final disabledBorderColor = outline.withValues(alpha: 0.12);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        style: TextStyle(
          fontFamily: 'Cairo-Bold',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: enabled ? onSurface : onSurface.withValues(alpha: 0.45),
        ),
        onTap: onTap,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        obscureText: obscureText,
        controller: controller,
        validator: validator,
        cursorColor: AppColors.kPrimaryColor,
        cursorWidth: 1.5,
        enabled: enabled,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        textInputAction: textInputAction,
        autofocus: autofocus,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          errorMaxLines: 3,
          suffixIcon: suffixIcon,
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  color: prefixIconColor ?? AppColors.kPrimaryColor,
                  size: 20,
                )
              : null,
          fillColor: defaultFill,
          filled: true,
          // Floating label
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: onSurface.withValues(alpha: 0.55),
          ),
          floatingLabelStyle: const TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.kPrimaryColor,
          ),
          // Hint
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(
                fontFamily: 'Cairo-Bold',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: onSurface.withValues(alpha: 0.30),
              ),
          // Error
          errorStyle: const TextStyle(
            fontFamily: 'Cairo-Bold',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.kRedColor,
          ),
          // Borders
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: enabledBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: enabledBorderColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: AppColors.kPrimaryColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: AppColors.kRedColor,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: AppColors.kRedColor,
              width: 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: disabledBorderColor,
              width: 1.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          counterText: counterText,
        ),
      ),
    );
  }
}
