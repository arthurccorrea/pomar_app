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
          debugShowCheckedModeBanner: false,
          locale: const Locale('pt', 'BR'),
          title: 'Pomar app',
          theme: ThemeData(
            primaryColor: Colors.green,
            appBarTheme: appBarTheme(),
            textTheme: textTheme(),
          ),
          home: const HomePage(),
        ));
  }

  AppBarTheme appBarTheme() {
    return const AppBarTheme(backgroundColor: Colors.green, centerTitle: true);
  }

  TextTheme textTheme() {
    return const TextTheme(bodyText2: TextStyle(color: Colors.white));
  }

}
