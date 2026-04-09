import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

final class SquaredButtons extends StatelessWidget {
  final IconData icon;
  final String title;
  final String path;
  const SquaredButtons({
    super.key,
    required this.icon,
    required this.title,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await context.push(path),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffD9D9D9),
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8.h,
          children: [
            Icon(icon, size: 72.w),
            Text(title),
          ],
        ),
      ),
    );
  }
}

/// Icons
/// study
/// settings
/// studia_controller
/// person
