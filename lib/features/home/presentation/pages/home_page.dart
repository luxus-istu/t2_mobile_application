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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 170.h,
                ),
                delegate: SliverChildListDelegate([
                  const SquaredButtons(
                    icon: Icons.school_outlined,
                    title: 'Обучение',
                    path: '/lessons',
                  ),
                  const SquaredButtons(
                    icon: Icons.sports_esports_outlined,
                    title: 'Игры',
                    path: '/games',
                  ),
                  const SquaredButtons(
                    icon: Icons.person_outline,
                    title: 'Профиль',
                    path: '/profile',
                  ),
                  const SquaredButtons(
                    icon: Icons.settings_outlined,
                    title: 'Настройки',
                    path: '/settings',
                  ),
                ]),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    Image.asset(
                      "assets/imgs/t2_find_lang.png",
                      fit: BoxFit.contain,
                    ),
                    Image.asset("assets/imgs/footer.png", fit: BoxFit.contain),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
