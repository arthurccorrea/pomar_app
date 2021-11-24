import 'package:flutter/material.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/pages/consulta/widgets/colheita_card.dart';

class ColheitaList extends StatelessWidget {
  final List<Colheita> colheitas;
  const ColheitaList({required this.colheitas, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return colheitas.isEmpty
        ? const _ColheitasVazias()
        : Padding(
            padding: const EdgeInsets.only(top: defaultVerticalPadding),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: defaultHorizontalPadding,
                  mainAxisSpacing: defaultHorizontalPadding,
                ),
                controller: ScrollController(),
                itemCount: colheitas.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    ColheitaCard(colheita: colheitas[index])),
          );
  }
}

class _ColheitasVazias extends StatelessWidget {
  const _ColheitasVazias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Não foram encontrado colheitas para essa consulta",
      textAlign: TextAlign.center,
    );
  }
}
