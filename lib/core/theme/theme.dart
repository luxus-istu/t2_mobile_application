import 'package:flutter/material.dart';

final class T2Theme {
  const T2Theme._();

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color magenta = Color(0xFFFF005A);
  static const Color surfaceSolid = Color(0xFF141414);

  static const String fontRooftop = 'Rooftop';
  static const String fontT2HalvarBreit = 'T2HalvarBreit';
  static const String fontT2HalvarStencilBreit = 'T2HalvarStencilBreit';

  static const TextStyle numberStyle = TextStyle(
    fontFamily: fontT2HalvarStencilBreit,
  );

  static ThemeData get darkTheme => ThemeData(
    fontFamily: fontRooftop,
    scaffoldBackgroundColor: black,
    primaryColor: magenta,
    colorScheme: const ColorScheme.dark(
      primary: magenta,
      surface: surfaceSolid,
      onSurface: white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: fontT2HalvarBreit),
      displayMedium: TextStyle(fontFamily: fontT2HalvarBreit),
      displaySmall: TextStyle(fontFamily: fontT2HalvarBreit),
      headlineLarge: TextStyle(fontFamily: fontT2HalvarBreit),
      headlineMedium: TextStyle(fontFamily: fontT2HalvarBreit),
      headlineSmall: TextStyle(fontFamily: fontT2HalvarBreit),
      titleLarge: TextStyle(fontFamily: fontT2HalvarBreit),
      titleMedium: TextStyle(fontFamily: fontT2HalvarBreit),
      titleSmall: TextStyle(fontFamily: fontT2HalvarBreit),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: magenta,
        foregroundColor: white,
        splashFactory: InkRipple.splashFactory,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: magenta,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentTextStyle: const TextStyle(
        fontFamily: fontT2HalvarBreit,
        fontWeight: FontWeight.w900,
        color: white,
      ),
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    fontFamily: fontRooftop,
    scaffoldBackgroundColor: white,
    primaryColor: magenta,
    colorScheme: const ColorScheme.light(
      primary: magenta,
      surface: white,
      onSurface: black,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: fontT2HalvarBreit),
      displayMedium: TextStyle(fontFamily: fontT2HalvarBreit),
      displaySmall: TextStyle(fontFamily: fontT2HalvarBreit),
      headlineLarge: TextStyle(fontFamily: fontT2HalvarBreit),
      headlineMedium: TextStyle(fontFamily: fontT2HalvarBreit),
      headlineSmall: TextStyle(fontFamily: fontT2HalvarBreit),
      titleLarge: TextStyle(fontFamily: fontT2HalvarBreit),
      titleMedium: TextStyle(fontFamily: fontT2HalvarBreit),
      titleSmall: TextStyle(fontFamily: fontT2HalvarBreit),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: magenta,
        foregroundColor: white,
        splashFactory: InkRipple.splashFactory,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: magenta,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentTextStyle: const TextStyle(
        fontFamily: fontT2HalvarBreit,
        fontWeight: FontWeight.w900,
        color: white,
      ),
    ),
  );
}
