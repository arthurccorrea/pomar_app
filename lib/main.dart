import 'package:flutter/material.dart';
import 'package:pomar_app/pages/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomar app',
      theme: ThemeData(
        appBarTheme: appBarTheme(),
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }

  AppBarTheme appBarTheme() {
    return const AppBarTheme(backgroundColor: Colors.green, centerTitle: true);
  }
}
