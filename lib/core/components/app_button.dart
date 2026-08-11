import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.isLoading = false,
    this.borderRadius = 12.0,
    this.height = 50.0,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.icon,
    this.iconAlignment = MainAxisAlignment.center,
  });

  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color iconColor;
  final Color textColor;
  final bool isLoading;
  final double borderRadius;
  final double height;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final IconData? icon;
  final MainAxisAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return Padding(
      padding: padding,
      child: Material(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: elevation,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          highlightColor: Colors.transparent,
          splashColor: Colors.white.withValues(alpha: 0.15),
          child: SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: isLoading ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: iconAlignment,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: iconColor, size: 18),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Cairo-Bold',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
