import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';

class T2TextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const T2TextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
  });

  @override
  Widget build(BuildContext ctx) {
    return TextField(
      inputFormatters: inputFormatters,
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: keyboardType == TextInputType.phone
          ? T2Theme.numberStyle.copyWith(
              color: Theme.of(ctx).colorScheme.onSurface,
            )
          : TextStyle(color: Theme.of(ctx).colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: Theme.of(ctx).colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(ctx).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: T2Theme.magenta, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
