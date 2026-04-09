import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';
import 'package:t2_mobile_application/features/games/presentation/widgets/quiz_scaffold.dart';

class ChooseTranslationPage extends StatefulWidget {
  const ChooseTranslationPage({super.key});

  @override
  State<ChooseTranslationPage> createState() => _ChooseTranslationPageState();
}

class _ChooseTranslationPageState extends State<ChooseTranslationPage> {
  @override
  void initState() {
    super.initState();
    sl<GamesCubit>().startGame('translate');
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider.value(
      value: sl<GamesCubit>(),
      child: BlocConsumer<GamesCubit, GamesState>(
        listener: (ctx, state) {
          if (state is QuizComplete) {
            ctx.pushReplacement('/games/result', extra: state);
          }
        },
        builder: (ctx, state) {
          if (state is GamesLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (state is QuizInProgress) {
            return QuizScaffold(
              title: 'Выбери перевод',
              progress: (state.currentIndex + 1) / state.totalQuestions,
              score: state.score,
              total: state.totalQuestions,
              body: Column(
                children: [
                  // Word card
                  Container(
                    width: double.infinity,
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
                          state.question.udmurt,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(ctx).colorScheme.onSurface,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            state.question.category,
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.6), 
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Выберите перевод:',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...state.options.map((opt) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _OptionButton(
                      label: opt,
                      onTap: () => sl<GamesCubit>().answerQuestion(opt),
                    ),
                  )),
                ],
              ),
            );
          }
          if (state is QuizAnswered) {
            return QuizScaffold(
              title: 'Выбери перевод',
              progress: (state.previous.currentIndex + 1) / state.previous.totalQuestions,
              score: state.previous.score,
              total: state.previous.totalQuestions,
              body: _AnswerFeedback(
                isCorrect: state.isCorrect,
                correctAnswer: state.correctAnswer,
                question: state.previous.question.udmurt,
                onNext: () => sl<GamesCubit>().nextQuestion(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OptionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext ctx) {
    return Material(
      color: Theme.of(ctx).colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(ctx).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _AnswerFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String question;
  final VoidCallback onNext;
  const _AnswerFeedback({
    required this.isCorrect,
    required this.correctAnswer,
    required this.question,
    required this.onNext,
  });

  @override
  Widget build(BuildContext ctx) {
    final color = isCorrect ? const Color(0xFF00C853) : T2Theme.magenta;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: color,
          size: 64.sp,
        ),
        SizedBox(height: 16.h),
        Text(
          isCorrect ? 'Верно! 🎉' : 'Неверно...',
          style: TextStyle(
            color: color,
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '«$question» — $correctAnswer',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(ctx).colorScheme.onSurface,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 32.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
            ),
            child: Text('Далее →',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
