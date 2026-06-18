import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constants/app_colors.dart';
import '../constants/app_shadows.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  AppToast._();

  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    required ToastType type,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color glowColor;
    const contentColor = Colors.white;
    IconData icon;
    String defaultTitle;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.toastSuccess;
        glowColor = AppColors.toastSuccess;
        icon = Icons.check_circle_rounded;
        defaultTitle = 'Success';
        break;
      case ToastType.error:
        backgroundColor = AppColors.toastError;
        glowColor = AppColors.toastError;
        icon = Icons.error_rounded;
        defaultTitle = 'Error';
        break;
      case ToastType.warning:
        backgroundColor = AppColors.toastWarning;
        glowColor = AppColors.toastWarning;
        icon = Icons.warning_rounded;
        defaultTitle = 'Warning';
        break;
      case ToastType.info:
        backgroundColor = AppColors.toastInfo;
        glowColor = AppColors.toastInfo;
        icon = Icons.info_rounded;
        defaultTitle = 'Info';
        break;
    }

    // Dismiss any existing toast before showing the new one
    _currentEntry?.remove();
    _currentEntry = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastOverlay(
        message: message,
        title: title ?? defaultTitle,
        backgroundColor: backgroundColor,
        glowColor: glowColor,
        contentColor: contentColor,
        icon: icon,
        duration: duration,
        onDismiss: () {
          entry.remove();
          if (_currentEntry == entry) _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    Overlay.of(context).insert(entry);
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
  }) {
    show(context, message: message, type: ToastType.success, title: title);
  }

  static void showError(BuildContext context, String message, {String? title}) {
    show(context, message: message, type: ToastType.error, title: title);
  }

  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
  }) {
    show(context, message: message, type: ToastType.warning, title: title);
  }

  static void showInfo(BuildContext context, String message, {String? title}) {
    show(context, message: message, type: ToastType.info, title: title);
  }
}

// ---------------------------------------------------------------------------
// Internal overlay widget — handles its own animation lifecycle
// ---------------------------------------------------------------------------

class _ToastOverlay extends StatefulWidget {
  final String message;
  final String title;
  final Color backgroundColor;
  final Color glowColor;
  final Color contentColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismiss;

  const _ToastOverlay({
    required this.message,
    required this.title,
    required this.backgroundColor,
    required this.glowColor,
    required this.contentColor,
    required this.icon,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 280),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto-dismiss after duration
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SlideTransition(
            position: _slideAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      // Colored glow
                      BoxShadow(
                        color: widget.glowColor.withValues(alpha: 0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      // Base shadow
                      ...AppShadows.toast,
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: widget.contentColor, size: 24),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: widget.contentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Gap(2),
                            Text(
                              widget.message,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: widget.contentColor.withValues(
                                      alpha: 0.85,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: _dismiss,
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
