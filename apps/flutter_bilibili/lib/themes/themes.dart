import 'package:flutter/material.dart';

class Themes {
  static const _lightPrimaryColorValue = 0xFFFF6699;
  static final lightTheme = ThemeData(
      backgroundColor: Colors.white,
      // textButtonTheme: TextButtonThemeData(style: ButtonStyle()),
      tabBarTheme: TabBarTheme(
          labelColor: lightPrimaryColor,
          unselectedLabelColor: Colors.black54,
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return states.contains(MaterialState.focused)
                ? null
                : Colors.transparent;
          })),
      primarySwatch: const MaterialColor(
        _lightPrimaryColorValue,
        <int, Color>{
          50: Color(0xFFFFF3F6),
          100: Color(0xFFFFECF1),
          200: Color(0xFFFFD9E4),
          300: Color(0xFFFFB3CA),
          400: Color(0xFFFF8CB0),
          500: Color(_lightPrimaryColorValue),
          600: Color(0xFFE84B85),
          700: Color(0xFFD03171),
          800: Color(0xFFAD1C5B),
          900: Color(0xFF771141),
        },
      ));

  static get lightPrimaryColor => const Color(_lightPrimaryColorValue);

  static final darkTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
  );
}
