import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';

final class SquaredButtons extends StatelessWidget {
  final IconData icon;
  final String title;
  final String path;
  
  const SquaredButtons({
    super.key,
    required this.icon,
    required this.title,
    required this.path,
  });

  @override
  Widget build(BuildContext ctx) {
    return Material(
      color: Theme.of(ctx).colorScheme.surface,
      borderRadius: BorderRadius.circular(28.r),
      elevation: 4,
      shadowColor: T2Theme.magenta.withValues(alpha: 0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(28.r),
        onTap: () {
          if (path.isNotEmpty) ctx.push(path);
        },
        splashColor: T2Theme.magenta.withValues(alpha: 0.2),
        highlightColor: T2Theme.magenta.withValues(alpha: 0.1),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.05),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: T2Theme.magenta.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon, 
                  size: 42.w, 
                  color: T2Theme.magenta,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(ctx).colorScheme.onSurface,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
