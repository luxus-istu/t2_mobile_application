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
                              color: Theme.of(
                                ctx,
                              ).colorScheme.onSurface.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getCategoryTitle(cat),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(ctx).colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.r),
                                      child: LinearProgressIndicator(
                                        value: progressPct,
                                        backgroundColor: Theme.of(ctx)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.1),
                                        color: T2Theme.magenta,
                                        minHeight: 6.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    '$viewedCount / $totalCount',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(ctx).colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
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
