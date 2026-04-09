import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:t2_mobile_application/features/tracking/presentation/bloc/tracking_cubit.dart';

final class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext ctx) {
    // Obtain reference to the singleton global tracker
    final trackingCubit = ctx.read<TrackingCubit>();
    final visitedPois = trackingCubit.visitedPois;
    final allPoisCount = trackingCubit.allPois.length;
    final percentage = allPoisCount > 0 ? (visitedPois.length / allPoisCount) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ПРОФИЛЬ',
          style: Theme.of(ctx).textTheme.displaySmall?.copyWith(fontSize: 33.sp),
        ),
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(ctx).colorScheme.onSurface),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
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
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(ctx).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Открыто мест и слов:',
                  style: TextStyle(color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.7)),
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
                  backgroundColor: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.1),
                  color: T2Theme.magenta,
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
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
                color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16.sp,
              ),
            )
          else
            ...visitedPois.map((poi) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: T2Theme.magenta.withValues(alpha: 0.3)),
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
                          color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )),
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
    );
  }
}
