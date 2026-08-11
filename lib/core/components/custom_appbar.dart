import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final TabBar? tabBar;
  final Widget? leading;
  final bool? automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Color? fontColor;
  final double? elevation;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool? centerTitle;
  final double? titleSpacing;
  final double? toolbarHeight;
  final ShapeBorder? shape;
  final bool? primary;
  final EdgeInsetsGeometry? toolbarPadding;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.tabBar,
    this.leading,
    this.automaticallyImplyLeading,
    this.backgroundColor,
    this.fontColor,
    this.shadowColor,
    this.elevation = 8.0,
    this.iconTheme,
    this.actionsIconTheme,
    this.centerTitle = true,
    this.titleSpacing,
    this.toolbarHeight,
    this.shape,
    this.primary,
    this.toolbarPadding,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      elevation: elevation,
      shadowColor: shadowColor ?? Colors.black,
      title: AppText(title, color: fontColor),
      centerTitle: centerTitle,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      backgroundColor: backgroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      shape: shape,
      systemOverlayStyle: systemOverlayStyle,
      flexibleSpace: Container(),
      bottom: tabBar == null
          ? null
          : PreferredSize(
              preferredSize: tabBar!.preferredSize,
              child: Container(
                color: Colors.white.withOpacity(0.15),
                child: tabBar!,
              ),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    toolbarHeight ?? (tabBar != null ? kToolbarHeight * 1.5 : kToolbarHeight),
  );
}
