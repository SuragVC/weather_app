import 'package:flutter/material.dart';
import 'package:weather_app/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLight = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isLight
          ? ThemeData.light(useMaterial3: true)
          : ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: HomePage(switchTheme: (value) {
        isLight = value;
        setState(() {});
      }),
    );
  }
}
