import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';

class GamesHubPage extends StatefulWidget {
  const GamesHubPage({super.key});

  @override
  State<GamesHubPage> createState() => _GamesHubPageState();
}

class _GamesHubPageState extends State<GamesHubPage> {
  @override
  void initState() {
    super.initState();
    sl<GamesCubit>().loadStats();
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider.value(
      value: sl<GamesCubit>(),
      child: Scaffold(
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
            'ИГРЫ',
            style: Theme.of(
              ctx,
            ).textTheme.displaySmall?.copyWith(fontSize: 30.sp),
          ),
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          elevation: 0,
        ),
        body: BlocBuilder<GamesCubit, GamesState>(
          builder: (ctx, state) {
            GameStats stats = const GameStats();
            if (state is GamesInitial) stats = state.stats;
            return ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                // Stats banner
                _StatsBanner(stats: stats),
                SizedBox(height: 24.h),
                Text(
                  'Выберите игру',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(ctx).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16.h),
                _GameCard(
                  emoji: '🔤',
                  title: 'Выбери перевод',
                  subtitle:
                      'Удмуртское слово — выбери правильный перевод из 4 вариантов.',
                  iconColor: Theme.of(
                    ctx,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                  onTap: () => ctx.push('/games/translate'),
                ),
                SizedBox(height: 12.h),
                _GameCard(
                  emoji: '🔀',
                  title: 'Составь слово',
                  subtitle:
                      'Угадай удмуртское слово по значению — собери буквы по порядку.',
                  iconColor: Theme.of(
                    ctx,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                  onTap: () => ctx.push('/games/compile'),
                ),
                SizedBox(height: 12.h),
                _GameCard(
                  emoji: '✅',
                  title: 'Верно / Неверно',
                  subtitle: 'Картинка и удмуртское слово — совпадают ли они?',
                  iconColor: Theme.of(
                    ctx,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                  onTap: () => ctx.push('/games/truefalse'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatsBanner extends StatelessWidget {
  final GameStats stats;
  const _StatsBanner({required this.stats});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(ctx).colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Твой прогресс',
                  style: TextStyle(
                    color: Theme.of(
                      ctx,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${stats.totalAnswered} ответов',
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.onSurface,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: stats.accuracy,
                    backgroundColor: Theme.of(
                      ctx,
                    ).colorScheme.onSurface.withValues(alpha: 0.1),
                    color: T2Theme.magenta,
                    minHeight: 6.h,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Точность: ${(stats.accuracy * 100).toInt()}%',
                  style: TextStyle(
                    color: Theme.of(
                      ctx,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          Text('🧠', style: TextStyle(fontSize: 48.sp)),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _GameCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext ctx) {
    return Material(
      color: Theme.of(ctx).colorScheme.surface,
      borderRadius: BorderRadius.circular(20.r),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: Theme.of(
                    ctx,
                  ).colorScheme.onSurface.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(emoji, style: TextStyle(fontSize: 28.sp)),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(ctx).colorScheme.onSurface,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(
                          ctx,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(
                  ctx,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
                size: 28.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
