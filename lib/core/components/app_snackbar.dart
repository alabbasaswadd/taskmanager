import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum SnackbarPosition { top, bottom }

/// Modern, minimal snackbar — message is the sole focus.
/// No type labels; icon indicates type visually.
///
/// Usage:
///   AppSnackbar.success(context, 'تم إنشاء المشروع بنجاح');
///   AppSnackbar.error(context, 'حدث خطأ أثناء تحميل البيانات');
///   AppSnackbar.warning(context, 'لا يوجد اتصال بالإنترنت');
///   AppSnackbar.info(context, 'سيتم تحديث البيانات قريباً');
class AppSnackbar {
  static OverlayEntry? _currentOverlay;

  // ── Public API ──────────────────────────────────────────────────────────────

  static void success(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      _show(context, message, _SnackType.success, position);

  static void error(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      _show(context, message, _SnackType.error, position);

  static void warning(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      _show(context, message, _SnackType.warning, position);

  static void info(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      _show(context, message, _SnackType.info, position);

  // Legacy aliases kept for backward-compat with existing call sites.
  static void showSuccess(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      success(context, message, position: position);

  static void showError(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      error(context, message, position: position);

  static void showWarning(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      warning(context, message, position: position);

  static void showInfo(
    BuildContext context,
    String message, {
    SnackbarPosition position = SnackbarPosition.top,
  }) =>
      info(context, message, position: position);

  // ── Core ────────────────────────────────────────────────────────────────────

  static void _show(
    BuildContext context,
    String message,
    _SnackType type,
    SnackbarPosition position,
  ) {
    if (position == SnackbarPosition.top) {
      _showTop(context, message, type);
    } else {
      _showBottom(context, message, type);
    }
  }

  static void _showTop(
    BuildContext context,
    String message,
    _SnackType type,
  ) {
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);
    final topPad = MediaQuery.of(context).padding.top;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _SnackWidget(
        message: message,
        type: type,
        topPadding: topPad,
        onDismiss: () {
          entry.remove();
          if (_currentOverlay == entry) _currentOverlay = null;
        },
      ),
    );

    _currentOverlay = entry;
    overlay.insert(entry);
  }

  static void _showBottom(
    BuildContext context,
    String message,
    _SnackType type,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: _SnackContent(
          message: message,
          config: _typeConfig(type),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// ── Type configuration ───────────────────────────────────────────────────────

enum _SnackType { success, error, warning, info }

class _TypeConfig {
  final Color accent;
  final IconData icon;

  const _TypeConfig({required this.accent, required this.icon});
}

_TypeConfig _typeConfig(_SnackType type) {
  switch (type) {
    case _SnackType.success:
      return const _TypeConfig(
        accent: AppColors.kSuccessColor,
        icon: Icons.check_circle_outline_rounded,
      );
    case _SnackType.error:
      return const _TypeConfig(
        accent: AppColors.kRedColor,
        icon: Icons.error_outline_rounded,
      );
    case _SnackType.warning:
      return const _TypeConfig(
        accent: AppColors.kWarningColor,
        icon: Icons.warning_amber_rounded,
      );
    case _SnackType.info:
      return const _TypeConfig(
        accent: AppColors.kInfoColor,
        icon: Icons.info_outline_rounded,
      );
  }
}

// ── Shared card content ──────────────────────────────────────────────────────

class _SnackContent extends StatelessWidget {
  final String message;
  final _TypeConfig config;
  final VoidCallback? onDismiss;

  const _SnackContent({
    required this.message,
    required this.config,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final msgColor =
        isDark ? Colors.white : const Color(0xFF0F172A); // Slate 900
    final dismissColor =
        isDark ? Colors.white30 : const Color(0xFF94A3B8); // Slate 400

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: BorderDirectional(
          start: BorderSide(color: config.accent, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: config.accent.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(config.icon, color: config.accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontFamily: 'Cairo-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: msgColor,
                      height: 1.55,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onDismiss != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDismiss,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: dismissColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Auto-dismiss progress bar at the bottom of the card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ProgressBar(color: config.accent),
          ),
        ],
      ),
    );
  }
}

// ── Progress bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final Color color;

  const _ProgressBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 4),
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (_, value, __) => ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppColors.radiusLg),
          bottomRight: Radius.circular(AppColors.radiusLg),
        ),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 3,
          backgroundColor: color.withValues(alpha: 0.10),
          valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.45)),
        ),
      ),
    );
  }
}

// ── Top-overlay animated widget ───────────────────────────────────────────────

class _SnackWidget extends StatefulWidget {
  final String message;
  final _SnackType type;
  final double topPadding;
  final VoidCallback onDismiss;

  const _SnackWidget({
    required this.message,
    required this.type,
    required this.topPadding,
    required this.onDismiss,
  });

  @override
  State<_SnackWidget> createState() => _SnackWidgetState();
}

class _SnackWidgetState extends State<_SnackWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    _ctrl.forward();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() => _ctrl.reverse().then((_) => widget.onDismiss());

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.topPadding + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: _SnackContent(
              message: widget.message,
              config: _typeConfig(widget.type),
              onDismiss: _dismiss,
            ),
          ),
        ),
      ),
    );
  }
}
