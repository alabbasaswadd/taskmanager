import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'app_text.dart';

/// Position where the snackbar should be displayed
enum SnackbarPosition { top, bottom }

class AppSnackbar {
  static OverlayEntry? _currentOverlay;

  static void showError(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.error,
      position: position,
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.success,
      position: position,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.info,
      position: position,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    _showSnackbar(
      context: context,
      message: message,
      type: SnackbarType.warning,
      position: position,
    );
  }

  static void _showSnackbar({
    required BuildContext context,
    required String message,
    required SnackbarType type,
    SnackbarPosition position = SnackbarPosition.bottom,
  }) {
    final snackbarData = _getSnackbarData(type);

    // Use overlay for top position, regular SnackBar for bottom
    if (position == SnackbarPosition.top) {
      _showTopSnackbar(context, message, snackbarData);
    } else {
      _showBottomSnackbar(context, message, snackbarData);
    }
  }

  static void _showTopSnackbar(
    BuildContext context,
    String message,
    SnackbarData snackbarData,
  ) {
    // Remove any existing overlay
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);
    final mediaQuery = MediaQuery.of(context);

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _TopSnackbarWidget(
        message: message,
        snackbarData: snackbarData,
        topPadding: mediaQuery.padding.top,
        onDismiss: () {
          overlayEntry.remove();
          if (_currentOverlay == overlayEntry) {
            _currentOverlay = null;
          }
        },
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);
  }

  static void _showBottomSnackbar(
    BuildContext context,
    String message,
    SnackbarData snackbarData,
  ) {
    final scaffold = ScaffoldMessenger.of(context);

    // إغلاق أي Snackbar سابق
    scaffold.hideCurrentSnackBar();

    scaffold.showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: snackbarData.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: snackbarData.backgroundColor.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                snackbarData.backgroundColor,
                snackbarData.backgroundColor.withOpacity(0.9),
              ],
            ),
          ),
          child: Row(
            children: [
              // أيقونة مع خلفية دائرية
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(snackbarData.icon, color: Colors.white, size: 22),
              ),

              const SizedBox(width: 16),

              // المحتوى النصي
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // العنوان
                    Row(
                      children: [
                        AppText(
                          snackbarData.title,
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                        // مؤشر التقدم
                        _buildProgressIndicator(snackbarData.backgroundColor),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // الرسالة
                    AppText(
                      message,
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // زر الإغلاق
              _buildCloseButton(scaffold, snackbarData),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(20),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // زر الإغلاق مع تصميم جميل
  static Widget _buildCloseButton(
    ScaffoldMessengerState scaffold,
    SnackbarData data,
  ) {
    return GestureDetector(
      onTap: () => scaffold.hideCurrentSnackBar(),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
      ),
    );
  }

  // مؤشر التقدم
  static Widget _buildProgressIndicator(Color baseColor) {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 4),
      tween: Tween<double>(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (value * 100).round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                flex: 100 - (value * 100).round(),
                child: const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  // بيانات الـ Snackbar حسب النوع
  static SnackbarData _getSnackbarData(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return SnackbarData(
          backgroundColor: AppColors.kRedColor,
          icon: Icons.error_outline_rounded,
          title: 'خطأ',
        );
      case SnackbarType.success:
        return SnackbarData(
          backgroundColor: _getSuccessColor(),
          icon: Icons.check_circle_outline_rounded,
          title: 'نجح',
        );
      case SnackbarType.info:
        return SnackbarData(
          backgroundColor: _getInfoColor(),
          icon: Icons.info_outline_rounded,
          title: 'معلومة',
        );
      case SnackbarType.warning:
        return SnackbarData(
          backgroundColor: _getWarningColor(),
          icon: Icons.warning_amber_outlined,
          title: 'تحذير',
        );
    }
  }

  static Color _getSuccessColor() {
    return Colors.green; // لون أخضر جميل
  }

  static Color _getInfoColor() {
    return const Color(0xFF3B82F6); // لون أزرق جميل
  }

  static Color _getWarningColor() {
    return Colors.orange; // لون أزرق جميل
  }
}

// كلاس مساعد لحفظ بيانات الـ Snackbar
class SnackbarData {
  final Color backgroundColor;
  final IconData icon;
  final String title;

  SnackbarData({
    required this.backgroundColor,
    required this.icon,
    required this.title,
  });
}

enum SnackbarType { error, success, info, warning }

/// Widget for displaying snackbar at the top of the screen
class _TopSnackbarWidget extends StatefulWidget {
  final String message;
  final SnackbarData snackbarData;
  final double topPadding;
  final VoidCallback onDismiss;

  const _TopSnackbarWidget({
    required this.message,
    required this.snackbarData,
    required this.topPadding,
    required this.onDismiss,
  });

  @override
  State<_TopSnackbarWidget> createState() => _TopSnackbarWidgetState();
}

class _TopSnackbarWidgetState extends State<_TopSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // Auto dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.topPadding + 10,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.snackbarData.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.snackbarData.backgroundColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    widget.snackbarData.backgroundColor,
                    widget.snackbarData.backgroundColor.withOpacity(0.9),
                  ],
                ),
              ),
              child: Row(
                children: [
                  // أيقونة مع خلفية دائرية
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.snackbarData.icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // المحتوى النصي
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // العنوان
                        Row(
                          children: [
                            AppText(
                              widget.snackbarData.title,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            const Spacer(),
                            // مؤشر التقدم
                            _buildProgressIndicator(),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // الرسالة
                        AppText(
                          widget.message,
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // زر الإغلاق
                  GestureDetector(
                    onTap: _dismiss,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 4),
      tween: Tween<double>(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            children: [
              Expanded(
                flex: (value * 100).round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                flex: 100 - (value * 100).round(),
                child: const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }
}
