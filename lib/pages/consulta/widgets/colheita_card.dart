import 'package:flutter/material.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/pages/colheita/cadastro_colheita.dart';

class ColheitaCard extends StatelessWidget {
  final Colheita colheita;
  const ColheitaCard({required this.colheita, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PageUtil.navigate(CadastroColheita(colheita: colheita), context);
      },
      child: Card(
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  colheita.informacoes,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  colheita.arvore != null ? colheita.arvore!.descricao : "Arvore não identificada",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
