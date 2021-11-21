import 'package:flutter/material.dart';
import 'package:pomar_app/pages/home/home.dart';
import 'package:pomar_app/pages/home/providers/pomar_list_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PomarListProvider(),
        child: MaterialApp(
          locale: Locale('pt', 'BR'),
          title: 'Pomar app',
          theme: ThemeData(
            appBarTheme: appBarTheme(),
          ),
          home: const HomePage(),
        ));
  }

  AppBarTheme appBarTheme() {
    return const AppBarTheme(backgroundColor: Colors.green, centerTitle: true);
  }
}
