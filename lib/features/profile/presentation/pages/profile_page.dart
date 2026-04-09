import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_state.dart';
import 'package:t2_mobile_application/features/games/domain/entities/game_stats.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_cubit.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_state.dart';
import 'package:t2_mobile_application/features/tracking/presentation/bloc/tracking_cubit.dart';

final class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext ctx) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<GamesCubit>().loadStats();
    });
    // Obtain reference to the singleton global tracker
    final trackingCubit = ctx.read<TrackingCubit>();
    final visitedPois = trackingCubit.visitedPois;
    final allPoisCount = trackingCubit.allPois.length;
    final percentage = allPoisCount > 0
        ? (visitedPois.length / allPoisCount)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ПРОФИЛЬ',
          style: Theme.of(
            ctx,
          ).textTheme.displaySmall?.copyWith(fontSize: 33.sp),
        ),
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(ctx).colorScheme.onSurface),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        children: [
          // Profile Header Section
          BlocBuilder<AuthCubit, AuthState>(
            bloc: sl<AuthCubit>(),
            builder: (context, state) {
              String phone = 'Загрузка...';
              String name = 'Пользователь T2';
              String gender = 'male';
              if (state is Authenticated) {
                phone = state.user.phone;
                name = '${state.user.firstName} ${state.user.lastName}'.trim();
                gender = state.user.gender;
                // Default fallback if they somehow bypassed name (e.g. old data before migration)
                if (name.isEmpty) name = 'Пользователь T2';
              }

              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(
                        ctx,
                      ).colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/imgs/arnament.png'),
                    fit: BoxFit.cover,
                    opacity: 0.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: T2Theme.magenta.withValues(alpha: 0.05),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 0.5.sw,
                      height: 0.5.sw,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(ctx).colorScheme.surface,
                        border: Border.all(color: T2Theme.magenta, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: T2Theme.magenta.withValues(alpha: 0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          gender == 'male'
                              ? 'assets/svgs/man_profile_img.svg'
                              : 'assets/svgs/woman_profile_img.svg',
                          width: 0.35.sw,
                          height: 0.35.sw,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(ctx).colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      phone,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          ctx,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 32.h),

          // Content block
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ваша статистика',
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.onSurface,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                // Location stats
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        ctx,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Открыто мест и слов:',
                        style: TextStyle(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${visitedPois.length} / $allPoisCount',
                            style: TextStyle(
                              color: T2Theme.magenta,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '${(percentage * 100).toInt()}%',
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.onSurface,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: Theme.of(
                          ctx,
                        ).colorScheme.onSurface.withValues(alpha: 0.1),
                        color: T2Theme.magenta,
                        minHeight: 8.h,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Lessons progress section
                BlocProvider.value(
                  value: sl<LessonsCubit>(),
                  child: BlocBuilder<LessonsCubit, LessonsState>(
                    builder: (_, state) {
                      int viewed = 0;
                      int total = 0;
                      if (state is LessonsLoaded) {
                        viewed = state.progress.viewedWordIds.length;
                        total = state.groupedWords.values
                            .expand((element) => element)
                            .length;
                      }
                      final pct = total > 0 ? viewed / total : 0.0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Изученные слова',
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.onSurface,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Theme.of(ctx).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(
                                  ctx,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$viewed / $total',
                                      style: TextStyle(
                                        color: T2Theme.magenta,
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      '${(pct * 100).toInt()}%',
                                      style: TextStyle(
                                        color: Theme.of(
                                          ctx,
                                        ).colorScheme.onSurface,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: Theme.of(ctx)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.1),
                                  color: T2Theme.magenta,
                                  minHeight: 8.h,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      );
                    },
                  ),
                ),
                // Games stats section
                BlocProvider.value(
                  value: sl<GamesCubit>(),
                  child: BlocBuilder<GamesCubit, GamesState>(
                    builder: (_, state) {
                      GameStats stats = const GameStats();
                      if (state is GamesInitial) stats = state.stats;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Игровой прогресс',
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.onSurface,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Theme.of(ctx).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(
                                  0xFF8800CC,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Всего ответов',
                                          style: TextStyle(
                                            color: Theme.of(ctx)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        Text(
                                          '${stats.totalAnswered}',
                                          style: TextStyle(
                                            color: const Color(0xFF8800CC),
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Точность',
                                          style: TextStyle(
                                            color: Theme.of(ctx)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.6),
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                        Text(
                                          '${(stats.accuracy * 100).toInt()}%',
                                          style: TextStyle(
                                            color: Theme.of(
                                              ctx,
                                            ).colorScheme.onSurface,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                LinearProgressIndicator(
                                  value: stats.accuracy,
                                  backgroundColor: Theme.of(ctx)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.1),
                                  color: const Color(0xFF8800CC),
                                  minHeight: 8.h,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                if (stats.totalPerGame.isNotEmpty) ...[
                                  SizedBox(height: 16.h),
                                  ...stats.totalPerGame.entries.map((e) {
                                    final svgAsset = switch (e.key) {
                                      'translate' =>
                                        'assets/svgs/translate.svg',
                                      'compile' => 'assets/svgs/crossword.svg',
                                      'truefalse' =>
                                        'assets/svgs/true_false.svg',
                                      _ => null,
                                    };
                                    final title = switch (e.key) {
                                      'translate' => 'Выбери перевод',
                                      'compile' => 'Составь слово',
                                      'truefalse' => 'Верно/Неверно',
                                      _ => e.key,
                                    };
                                    final correct =
                                        stats.correctPerGame[e.key] ?? 0;
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 8.h),
                                      child: Row(
                                        children: [
                                          if (svgAsset != null) ...[
                                            SvgPicture.asset(
                                              svgAsset,
                                              width: 18.w,
                                              height: 18.w,
                                              colorFilter: ColorFilter.mode(
                                                Theme.of(ctx)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.7),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                          ],
                                          Expanded(
                                            child: Text(
                                              title,
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ),
                                          Text(
                                            '$correct/${e.value}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF8800CC),
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'История посещений',
                  style: TextStyle(
                    color: Theme.of(ctx).colorScheme.onSurface,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                if (visitedPois.isEmpty)
                  Text(
                    'Вы пока ничего не посетили. Включите геолокацию в настройках и отправляйтесь на улицу!',
                    style: TextStyle(
                      color: Theme.of(
                        ctx,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 16.sp,
                    ),
                  )
                else
                  ...visitedPois.map(
                    (poi) => Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: T2Theme.magenta.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            poi.title,
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.onSurface,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            poi.description,
                            style: TextStyle(
                              color: Theme.of(
                                ctx,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: T2Theme.magenta,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    onPressed: () {
                      sl<AuthCubit>().logout();
                      ctx.go('/login');
                    },
                    child: Text(
                      'Выйти из профиля',
                      style: TextStyle(
                        color: T2Theme.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
