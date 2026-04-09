import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:t2_mobile_application/features/home/presentation/widgets/squared_buttons.dart';

final class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/svgs/Udmurtia-Flag.svg", width: 52),
            Text(
              'УДМУРТ КЫЛ',
              style: Theme.of(
                ctx,
              ).textTheme.displaySmall?.copyWith(fontSize: 33.sp),
            ),
          ],
        ),
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        elevation: 0,
      ),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 170.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          SquaredButtons(
            icon: Icons.school_outlined,
            title: 'Обучение',
            path: '',
          ),
          SquaredButtons(
            icon: Icons.sports_esports_outlined,
            title: 'Игры',
            path: '/games',
          ),
          SquaredButtons(
            icon: Icons.person_outline,
            title: 'Профиль',
            path: '/profile',
          ),
          SquaredButtons(
            icon: Icons.settings_outlined,
            title: 'Настройки',
            path: '/settings',
          ),
        ],
      ),
    );
  }
}
