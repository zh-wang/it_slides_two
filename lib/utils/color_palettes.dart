import 'package:flutter/material.dart';

abstract class BaseTheme {

  final Color slider1 = const Color(0);
  final Color slider2 = const Color(0);
  final Color target1 = const Color(0);
  final Color target2 = const Color(0);
  final Color bg = const Color(0);
  final Color wall = const Color(0);
  final Color primaryColor = const Color(0);
  final Color textColor = const Color(0);
}

// class ThemeLight implements BaseTheme {
//
//   const ThemeLight();
//
//   @override
//   Color get slider1 => const Color(0xFFBDD2B6);
//
//   @override
//   Color get slider2 => const Color(0xFFFFBCBC);
//
//   @override
//   Color get target1 => const Color(0xFFA2B29F);
//
//   @override
//   Color get target2 => const Color(0xFFF38BA0);
//
//   @override
//   Color get bg => const Color(0xFFF8EDE3);
//
//   @override
//   Color get wall => const Color(0xFF798777);
//
//   @override
//   Color get primaryColor => Colors.lime;
//
//   @override
//   Color get textColor => Colors.lime;
// }

class ThemeDark implements BaseTheme {

  const ThemeDark();

  @override
  Color get slider1 => const Color(0xFFE11D47);

  @override
  Color get slider2 => const Color(0xFF5463FF);

  @override
  Color get target1 => const Color(0x88E11D47);

  @override
  Color get target2 => const Color(0x885463FF);

  @override
  Color get bg => const Color(0xFF52057B);

  @override
  Color get wall => const Color(0xFF7E7474);

  @override
  Color get primaryColor => const Color(0xFFFEC260);

  @override
  Color get textColor => const Color(0xFFEFEFEF);
}

class ThemeLight implements BaseTheme {

  const ThemeLight();

  @override
  Color get slider1 => const Color(0xFFE02401);

  @override
  Color get slider2 => const Color(0xFF5463FF);

  @override
  Color get target1 => const Color(0x88E02401);

  @override
  Color get target2 => const Color(0x885463FF);

  @override
  Color get bg => const Color(0xFFEEEBDD);

  @override
  Color get wall => const Color(0xFFAD8B73);

  @override
  Color get primaryColor => const Color(0xFFFFB70B);

  @override
  Color get textColor => const Color(0xFF121212);
}
