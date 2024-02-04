import 'package:flutter/material.dart';
import 'package:qchat/common/global.dart';

ThemeData buildLightTheme(ColorScheme? lightColorScheme) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    // fontFamily: 'SarasaUISC',
    colorScheme:
        prefs.getBool('useDynamicColor') ?? true ? lightColorScheme : null,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: const DividerThemeData(
      space: 0,
      indent: 18,
      endIndent: 18,
    ),
  );
}

ThemeData buildDarkTheme(ColorScheme? darkColorScheme) {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    // fontFamily: 'SarasaUISC',
    colorScheme:
        prefs.getBool('useDynamicColor') ?? true ? darkColorScheme : null,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: const DividerThemeData(
      space: 0,
      indent: 18,
      endIndent: 18,
    ),
  );
}
