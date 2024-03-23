import 'package:flutter/material.dart';

import 'color_schemes.g.dart';

class AppTheme {
  static final _border = OutlineInputBorder(
      borderSide: BorderSide(width: 1),
      borderRadius: BorderRadius.circular(14),
  );
  static final darkTheme =
      ThemeData(useMaterial3: true, colorScheme: darkColorScheme).copyWith(
        backgroundColor: darkColorScheme.onPrimaryContainer,
          inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.all(27),
              enabledBorder: _border,
              focusedBorder: _border.copyWith(
                borderSide: BorderSide(color: darkColorScheme.tertiary)
              )));

  static final lightTheme =
      ThemeData(useMaterial3: true, colorScheme: lightColorScheme).copyWith(
          inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.all(27),
              enabledBorder: _border,
              focusedBorder: _border.copyWith(
                  borderSide: BorderSide(color: lightColorScheme.tertiary)
              )));
}
