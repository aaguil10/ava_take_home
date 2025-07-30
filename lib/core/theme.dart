import 'package:ava_take_home/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme _myScheme = ColorScheme.fromSeed(seedColor: primaryPurple)
    .copyWith(
      primary: primaryPurple,
      secondary: secondaryGreen,
      surface: creamBackground,
    );

final ThemeData appTheme = ThemeData(
  textTheme: GoogleFonts.playballTextTheme(), // Closest to 'At Hauss' font
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),
  colorScheme: _myScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: _myScheme.primary,
    titleTextStyle: GoogleFonts.playball(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
