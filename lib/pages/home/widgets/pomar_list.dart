import 'package:flutter/material.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/pages/home/providers/pomar_list_provider.dart';
import 'package:pomar_app/pages/home/widgets/pomar_card.dart';
import 'package:provider/provider.dart';

class PomarList extends StatefulWidget {
  const PomarList({Key? key}) : super(key: key);

  @override
  _PomarListState createState() => _PomarListState();
}

class _PomarListState extends State<PomarList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PomarListProvider>(
      builder: (context, value, child) => value.pomares.isEmpty
          ? const _PomaresVazio()
          : GridView.builder(
              shrinkWrap: true,
              controller: ScrollController(),
              padding: const EdgeInsets.only(top: defaultHorizontalPadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: defaultHorizontalPadding,
                  mainAxisSpacing: defaultHorizontalPadding),
              itemCount: value.pomares.length,
              itemBuilder: (context, index) => PomarCard(
                pomar: value.pomares[index],
              ),
            ),
    );
  }
}

class _PomaresVazio extends StatelessWidget {
  const _PomaresVazio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Você ainda não tem pomares\nCadastre o seu primeiro pomar tocando no botão abaixo",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
