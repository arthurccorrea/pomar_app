import 'package:flutter/material.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/home/widgets/list_pomar.dart';
import 'package:pomar_app/pages/pomar/cadastro_pomar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pomar> pomares = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pomar-App"),
      ),
      body: Column(
        children: const [
          ListPomar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PageUtil.navigate(CadastroPomar(pomar: Pomar()), context);
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
