import 'package:flutter/material.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/home/widgets/pomar_card.dart';

class ListPomar extends StatefulWidget {
  const ListPomar({Key? key}) : super(key: key);

  @override
  _ListPomarState createState() => _ListPomarState();
}

class _ListPomarState extends State<ListPomar> {
  List<Pomar> pomares = [];
  @override
  Widget build(BuildContext context) {
    return pomares.isEmpty
        ? const _PomaresVazio()
        : ListView.builder(
            itemCount: pomares.length,
            itemBuilder: (context, index) => PomarCard(
              pomar: pomares[index],
            ),
          );
  }
}

class _PomaresVazio extends StatelessWidget {
  const _PomaresVazio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: GradientContainerBody(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Center(
          child: Text(
            "Você ainda não tem pomares\nCadastre o seu primeiro pomar clicando no botão abaixo",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
