import 'package:flutter/material.dart';
import 'package:qchat/common/prefs_helper.dart';

ThemeData buildLightTheme(ColorScheme? lightColorScheme) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: PrefsHelper.themeFont,
    colorScheme: PrefsHelper.useDynamicColor ? lightColorScheme : null,
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
    fontFamily: PrefsHelper.themeFont,
    colorScheme: PrefsHelper.useDynamicColor ? darkColorScheme : null,
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
