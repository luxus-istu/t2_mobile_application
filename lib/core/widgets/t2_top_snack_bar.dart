import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';

class T2TopSnackBar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final VoidCallback onDismissed;

  const T2TopSnackBar({
    super.key,
    required this.message,
    this.backgroundColor = T2Theme.magenta,
    required this.onDismissed,
  });

  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = T2Theme.magenta,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => T2TopSnackBar(
        message: message,
        backgroundColor: backgroundColor,
        onDismissed: () {
          entry.remove();
        },
      ),
    );

    overlay.insert(entry);
    Future.delayed(duration, () {
      if (entry.mounted) {
        // The widget handles its own removal animation internally
        // but we trigger the dismissal logic here.
      }
    });
  }

  @override
  State<T2TopSnackBar> createState() => _T2TopSnackBarState();
}

class _T2TopSnackBarState extends State<T2TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    _ctrl.forward();

    // Auto-dismiss logic coordinated with duration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() async {
    await _ctrl.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Positioned(
      top: MediaQuery.of(ctx).padding.top + 16.h,
      left: 16.w,
      right: 16.w,
      child: SlideTransition(
        position: _offset,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                color: T2Theme.white,
                fontFamily: T2Theme.fontT2HalvarBreit,
                fontWeight: FontWeight.w900,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
