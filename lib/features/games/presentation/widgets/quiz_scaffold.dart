import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';

class QuizScaffold extends StatelessWidget {
  final String title;
  final double progress;
  final int score;
  final int total;
  final Widget body;

  const QuizScaffold({
    super.key,
    required this.title,
    required this.progress,
    required this.score,
    required this.total,
    required this.body,
  });

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(ctx).textTheme.displaySmall?.copyWith(fontSize: 22.sp),
        ),
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Text(
                '⭐ $score',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: T2Theme.magenta,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6.h),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor:
                Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.08),
            color: T2Theme.magenta,
            minHeight: 5.h,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: body,
      ),
    );
  }
}
