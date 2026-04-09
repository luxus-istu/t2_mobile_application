import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';
import 'package:t2_mobile_application/features/games/presentation/widgets/quiz_scaffold.dart';
import 'package:t2_mobile_application/core/utils/sound_helper.dart';

class TrueFalsePage extends StatefulWidget {
  const TrueFalsePage({super.key});

  @override
  State<TrueFalsePage> createState() => _TrueFalsePageState();
}

class _TrueFalsePageState extends State<TrueFalsePage> {
  @override
  void initState() {
    super.initState();
    sl<GamesCubit>().startGame('truefalse');
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider.value(
      value: sl<GamesCubit>(),
      child: BlocConsumer<GamesCubit, GamesState>(
        listener: (ctx, state) {
          if (state is QuizAnswered) {
             SoundHelper.playSound(state.isCorrect ? 'right.mp3' : 'error.mp3');
          }
          if (state is QuizComplete) {
            ctx.pushReplacement('/games/result', extra: state);
          }
        },
        builder: (ctx, state) {
          if (state is GamesLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is QuizInProgress) {
            final shownUdmurt = state.options[0];
            return QuizScaffold(
              title: 'Верно / Неверно',
              progress: (state.currentIndex + 1) / state.totalQuestions,
              score: state.score,
              total: state.totalQuestions,
              body: Column(
                children: [
                  SizedBox(height: 16.h),
                  Text(state.question.emoji, style: TextStyle(fontSize: 80.sp)),
                  SizedBox(height: 16.h),
                  Text(
                    state.question.russian,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(
                        ctx,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(ctx).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: T2Theme.magenta.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: T2Theme.magenta.withValues(alpha: 0.08),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Text(
                      shownUdmurt,
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w900,
                        color: T2Theme.magenta,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),
                  Row(
                    children: [
                      Expanded(
                        child: _TFButton(
                          label: '✓  ВЕРНО',
                          color: const Color(0xFF00C853),
                          onTap: () => sl<GamesCubit>().answerTrueFalse(true),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _TFButton(
                          label: '✗  НЕВЕРНО',
                          color: T2Theme.magenta,
                          onTap: () => sl<GamesCubit>().answerTrueFalse(false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          if (state is QuizAnswered) {
            final color = state.isCorrect
                ? const Color(0xFF00C853)
                : T2Theme.magenta;
            return QuizScaffold(
              title: 'Верно / Неверно',
              progress:
                  (state.previous.currentIndex + 1) /
                  state.previous.totalQuestions,
              score: state.previous.score,
              total: state.previous.totalQuestions,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 32.h),
                  Text(
                    state.previous.question.emoji,
                    style: TextStyle(fontSize: 80.sp),
                  ),
                  SizedBox(height: 24.h),
                  Icon(
                    state.isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: color,
                    size: 64.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    state.isCorrect ? 'Правильно! 🎉' : 'Неверно...',
                    style: TextStyle(
                      color: color,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.correctAnswer,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(ctx).colorScheme.onSurface,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => sl<GamesCubit>().nextQuestion(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Далее →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TFButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _TFButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    return Material(
      color: Theme.of(ctx).colorScheme.surface,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          height: 72.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            color: color.withValues(alpha: 0.05),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
