import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_cubit.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_state.dart';

class LessonsTopicsPage extends StatefulWidget {
  const LessonsTopicsPage({super.key});

  @override
  State<LessonsTopicsPage> createState() => _LessonsTopicsPageState();
}

class _LessonsTopicsPageState extends State<LessonsTopicsPage> {
  @override
  void initState() {
    super.initState();
    sl<LessonsCubit>().loadData();
  }

  String _getCategoryTitle(String cat) {
    return switch (cat) {
      'greetings' => 'Приветствия',
      'numbers' => 'Числа (1-10)',
      'wild_animals' => 'Дикие животные',
      'domestic_animals' => 'Домашние животные',
      'food' => 'Продукты, еда',
      'family' => 'Моя семья',
      'vegetables' => 'Овощи',
      'colors' => 'Цвета',
      'berries' => 'Ягоды',
      'phrases' => 'Базовые фразы',
      _ => cat,
    };
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (ctx.canPop()) {
              ctx.pop();
            } else {
              ctx.go('/home');
            }
          },
        ),
        title: Text(
          'ОБУЧЕНИЕ',
          style: Theme.of(
            ctx,
          ).textTheme.displaySmall?.copyWith(fontSize: 30.sp),
        ),
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocProvider.value(
          value: sl<LessonsCubit>(),
          child: BlocBuilder<LessonsCubit, LessonsState>(
            builder: (ctx, state) {
              if (state is LessonsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is LessonsLoaded) {
                final topics = state.groupedWords.keys.toList();

                return ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: topics.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (ctx, idx) {
                    final cat = topics[idx];
                    final words = state.groupedWords[cat]!;
                    final viewedCount = words
                        .where(
                          (w) => state.progress.viewedWordIds.contains(w.id),
                        )
                        .length;
                    final totalCount = words.length;
                    final progressPct = viewedCount / totalCount;

                    final isPassed = viewedCount == totalCount;
                    final isStarted =
                        viewedCount > 0 && viewedCount < totalCount;

                    final borderColor = isPassed
                        ? const Color(0xFFA7FC00).withValues(alpha: 0.3)
                        : isStarted
                        ? Theme.of(
                            ctx,
                          ).colorScheme.primary.withValues(alpha: 0.3)
                        : Theme.of(
                            ctx,
                          ).colorScheme.onSurface.withValues(alpha: 0.1);

                    return Material(
                      color: Theme.of(ctx).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () => ctx.push('/lessons/cards', extra: cat),
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: borderColor,
                              width: (isPassed || isStarted) ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _getCategoryTitle(cat),
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          ctx,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (isPassed)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFFA7FC00),
                                    ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                isPassed
                                    ? 'МОЛОДЕЦ'
                                    : '$viewedCount / $totalCount',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: T2Theme.fontT2HalvarBreit,
                                  color: isPassed
                                      ? const Color(0xFFA7FC00)
                                      : Theme.of(ctx).colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: progressPct,
                                  backgroundColor: Theme.of(ctx)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.1),
                                  color: isPassed
                                      ? const Color(0xFFA7FC00)
                                      : T2Theme.magenta,
                                  minHeight: 6.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
