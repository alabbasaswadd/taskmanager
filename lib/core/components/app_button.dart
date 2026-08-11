import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.kPrimaryColor,
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

  final text;
  final Function() onPressed;
  final Color color;
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
    return Padding(
      padding: padding,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: elevation,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                colors: [color, Color.lerp(color, Colors.black, 0.1)!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: isLoading ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: iconAlignment,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: iconColor),
                        const SizedBox(width: 8),
                      ],
                      AppText(text, color: Colors.white),
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
