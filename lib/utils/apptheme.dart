

import 'package:flutter/material.dart';

class AppTheme {
  ThemeData themeData = ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFF20ac6d),
        background: Colors.white,
        onBackground: Colors.white,
      ),
      highlightColor: const Color(0xFF7fe6be),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFFe9fbf3),
      ),
      backgroundColor: Colors.white,
      //Color(0xFFe9fbf3),
      canvasColor: Colors.white,
      // const Color(0xFFe9fbf3),
      textTheme: TextTheme(
        headline5: ThemeData.light()
            .textTheme
            .headline5!
            .copyWith(color: const Color(0xFF20ac6d)),
      ),
      iconTheme: IconThemeData(
        color: Colors.grey[600],
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF20ac6d),
        centerTitle: false,
        foregroundColor: Colors.white,
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xFF20ac6d)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFF20ac6d),
          ),
          side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Color(0xFF20ac6d))),
        ),
      ));
}