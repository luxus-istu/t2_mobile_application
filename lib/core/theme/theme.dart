import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class T2Theme {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color magenta = Color(0xFFFF005A);
  static const Color surfaceSolid = Color(0xFF141414);

  static ThemeData get darkTheme => ThemeData(
    scaffoldBackgroundColor: black,
    primaryColor: magenta,
    colorScheme: const ColorScheme.dark(
      primary: magenta,
      surface: surfaceSolid,
      onSurface: white,
    ),
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: white,
      displayColor: white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: magenta,
        foregroundColor: white,
        splashFactory: InkRipple.splashFactory,
        shape: const BeveledRectangleBorder(), // Edgy, flat aesthetic
        textStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    ),
  );
}
