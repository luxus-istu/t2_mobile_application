import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';

class GameResultPage extends StatelessWidget {
  final QuizComplete result;
  const GameResultPage({super.key, required this.result});

  String get _gameLabel {
    return switch (result.gameKey) {
      'translate' => 'Выбери перевод',
      'compile' => 'Составь слово',
      'truefalse' => 'Верно / Неверно',
      _ => 'Игра',
    };
  }

  String get _grade {
    final pct = result.score / result.total;
    if (pct >= 0.9) return '🏆 Отлично!';
    if (pct >= 0.7) return '🌟 Хорошо!';
    if (pct >= 0.5) return '👍 Неплохо!';
    return '💪 Продолжай!';
  }

  @override
  Widget build(BuildContext ctx) {
    final pct = result.score / result.total;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_grade, style: TextStyle(fontSize: 48.sp)),
              SizedBox(height: 16.h),
              Text(
                _gameLabel,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 32.h),
              Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${result.score} / ${result.total}',
                      style: TextStyle(
                        color: Theme.of(ctx).colorScheme.onSurface,
                        fontSize: 56.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'правильных ответов',
                      style: TextStyle(
                        color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.6), 
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: LinearProgressIndicator(
                        value: pct,
                        backgroundColor: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1),
                        color: pct >= 0.7 ? const Color(0xFF00C853) : T2Theme.magenta,
                        minHeight: 8.h,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '${(pct * 100).toInt()}%',
                      style: TextStyle(
                        color: Theme.of(ctx).colorScheme.onSurface, 
                        fontSize: 20.sp, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    // refresh stats then pop back to hub
                    sl<GamesCubit>().loadStats();
                    ctx.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: T2Theme.magenta,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: Text('В меню игр',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => ctx.go('/home'),
                child: Text(
                  'На главную',
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
