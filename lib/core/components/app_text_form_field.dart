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
    this.horizontalPadding = 0.0, // المسافة الجانبية الافتراضية
    this.borderRadius = 8.0, // نصف قطر الحواف الافتراضي
    this.fillColor, // لون الخلفية
    this.enabled = true, // هل الحقل مفعل
    this.onChanged, // دالة عند تغيير النص
    this.onEditingComplete, // دالة عند اكمال التحرير
    this.onFieldSubmitted, // دالة عند إرسال الحقل
    this.focusNode, // عقدة التركيز
    this.textInputAction, // إجراء زر الإدخال
    this.autofocus = false, // التركيز التلقائي
    this.maxLines = 1, // عدد الأسطر
    this.minLines, // أقل عدد أسطر
    this.maxLength, // أقصى طول
    this.counterText, // نص العداد
    this.hintText, // نص تلميح
    this.hintStyle, // نمط نص التلميح
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
  final double horizontalPadding; // المسافة الجانبية
  final double borderRadius; // نصف قطر الحواف الدائرية
  final Color? fillColor; // لون خلفية الحقل
  final bool enabled; // حالة تفعيل الحقل
  final ValueChanged<String>? onChanged; // عند تغيير النص
  final VoidCallback? onEditingComplete; // عند اكمال التحرير
  final ValueChanged<String>? onFieldSubmitted; // عند إرسال الحقل
  final FocusNode? focusNode; // عقدة التركيز
  final TextInputAction? textInputAction; // إجراء زر الإدخال
  final bool autofocus; // التركيز التلقائي
  final int? maxLines; // الحد الأقصى للأسطر
  final int? minLines; // الحد الأدنى للأسطر
  final int? maxLength; // الحد الأقصى للأحرف
  final String? counterText; // نص عداد الأحرف
  final String? hintText; // نص تلميح داخل الحقل
  final TextStyle? hintStyle; // نمط نص التلميح

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          elevation: 0, // ارتفاع ظل البطاقة
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: TextFormField(
            style: TextStyle(
              fontFamily: 'Cairo-Bold',
              fontSize: 13,
              color: enabled
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onTap: onTap,
            readOnly: readOnly ?? false,
            keyboardType: keyboardType,
            obscureText: obscureText,
            controller: controller,
            validator: validator,
            cursorColor: AppColors.kPrimaryColor,
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
                    )
                  : null,
              fillColor: fillColor ?? Colors.transparent,
              filled: true,
              labelText: label,
              labelStyle: TextStyle(
                fontFamily: 'Cairo-Bold',
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              hintText: hintText,
              hintStyle:
                  hintStyle ??
                  const TextStyle(fontFamily: 'Cairo-Bold', fontSize: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.error, // لون البوردر الافتراضي
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.kPrimaryColor, // لون عند التركيز
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Colors.red, // لون الخطأ
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: Colors.red, // لون الخطأ مع التركيز
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary, // لون الحقل المعطّل
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              counterText: counterText,
            ),
          ),
        ),
      ),
    );
  }
}
