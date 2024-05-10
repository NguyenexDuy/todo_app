import 'package:flutter/material.dart';
import 'package:todos_flutter/themes/dark_theme.dart';
import 'package:todos_flutter/themes/light_theme.dart';

import 'pages/home_page.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
