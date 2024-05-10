import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.yellow[300],
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        )),
    colorScheme: ColorScheme.light(
        background: Colors.yellow[100]!,
        primary: Colors.yellow[200]!,
        secondary: Colors.yellow[300]!));
