import 'package:flutter/material.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/home/providers/pomar_list_provider.dart';
import 'package:pomar_app/pages/home/widgets/pomar_future_builder.dart';
import 'package:pomar_app/pages/pomar/cadastro_pomar.dart';
import 'package:provider/provider.dart';

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
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text("Pomar-App"),
      ),
      body: GradientContainerBody(
        padding: const EdgeInsets.only(
            left: defaultHorizontalPadding, right: defaultHorizontalPadding),
        child: ListView(
          children: const [
            PomarFutureBuilder(),
          ],
        ),
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
