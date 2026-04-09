import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';
import 'package:t2_mobile_application/features/games/presentation/widgets/quiz_scaffold.dart';

class CompileWordPage extends StatefulWidget {
  const CompileWordPage({super.key});

  @override
  State<CompileWordPage> createState() => _CompileWordPageState();
}

class _CompileWordPageState extends State<CompileWordPage>
    with SingleTickerProviderStateMixin {
  List<String> _assembled = [];
  List<String> _tilePool = [];
  bool _shaking = false;
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    sl<GamesCubit>().startGame('compile');
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _shakeAnim = Tween<double>(
      begin: 0,
      end: 10,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeCtrl);
    _shakeCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        _shakeCtrl.reverse();
        setState(() => _shaking = false);
      }
    });
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _initTiles(String word) {
    _tilePool = word.split('').toList()..shuffle();
    _assembled = [];
  }

  void _tapTile(String letter, int index) {
    setState(() {
      _assembled.add(letter);
      _tilePool.removeAt(index);
    });
  }

  void _removeLast() {
    if (_assembled.isEmpty) return;
    setState(() {
      _tilePool.add(_assembled.removeLast());
    });
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
          if (state is QuizInProgress &&
              _assembled.isEmpty &&
              _tilePool.isEmpty) {
            _initTiles(state.question.udmurt);
          }
          if (state is QuizInProgress) {
            // reset on new question
            if (_tilePool.isEmpty && _assembled.isEmpty) {
              _initTiles(state.question.udmurt);
            }
          }
        },
        builder: (ctx, state) {
          if (state is GamesLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is QuizInProgress) {
            if (_tilePool.isEmpty && _assembled.isEmpty) {
              _initTiles(state.question.udmurt);
            }
            return QuizScaffold(
              title: 'Составь слово',
              progress: (state.currentIndex + 1) / state.totalQuestions,
              score: state.score,
              total: state.totalQuestions,
              body: Column(
                children: [
                  SizedBox(height: 8.h),
                  Text(state.question.emoji, style: TextStyle(fontSize: 72.sp)),
                  SizedBox(height: 8.h),
                  Text(
                    state.question.russian,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(ctx).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Answer row
                  AnimatedBuilder(
                    animation: _shakeAnim,
                    builder: (_, child) => Transform.translate(
                      offset: _shaking
                          ? Offset(_shakeAnim.value, 0)
                          : Offset.zero,
                      child: child,
                    ),
                    child: GestureDetector(
                      onTap: _removeLast,
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(minHeight: 58.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(ctx).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: T2Theme.magenta.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: Wrap(
                          spacing: 4,
                          children: _assembled.isEmpty
                              ? [
                                  Text(
                                    'Коснитесь букв ниже...',
                                    style: TextStyle(
                                      color: Theme.of(ctx).colorScheme.onSurface
                                          .withValues(alpha: 0.3),
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ]
                              : _assembled
                                    .map(
                                      (l) => Text(
                                        l,
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w900,
                                          color: T2Theme.magenta,
                                        ),
                                      ),
                                    )
                                    .toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '← нажмите чтобы удалить последнюю букву',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Theme.of(
                        ctx,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Letter tiles
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: List.generate(_tilePool.length, (i) {
                      return GestureDetector(
                        onTap: () => _tapTile(_tilePool[i], i),
                        child: Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: T2Theme.magenta.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: T2Theme.magenta.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _tilePool[i],
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(ctx).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _assembled.isEmpty
                          ? null
                          : () {
                              final word = _assembled.join();
                              final cubit = sl<GamesCubit>();
                              final st = cubit.state;
                              if (st is QuizInProgress) {
                                final isCorrect = word == st.question.udmurt;
                                if (!isCorrect) {
                                  setState(() => _shaking = true);
                                  _shakeCtrl.forward();
                                }
                                cubit.answerCompile(word);
                                _assembled = [];
                                _tilePool = [];
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: T2Theme.magenta,
                        disabledBackgroundColor: T2Theme.magenta.withValues(
                          alpha: 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'ПРОВЕРИТЬ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is QuizAnswered) {
            final color = state.isCorrect
                ? const Color(0xFF00C853)
                : T2Theme.magenta;
            // Reset tiles for next question
            _assembled = [];
            _tilePool = [];
            return QuizScaffold(
              title: 'Составь слово',
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
                    'Правильно: «${state.correctAnswer}»',
                    style: TextStyle(
                      color: Theme.of(ctx).colorScheme.onSurface,
                      fontSize: 18.sp,
                    ),
                    textAlign: TextAlign.center,
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
