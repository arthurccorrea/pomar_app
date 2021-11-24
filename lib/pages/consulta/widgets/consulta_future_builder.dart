import 'package:flutter/material.dart';
import 'package:pomar_app/core/widgets/loading_page.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/pages/consulta/widgets/colheita_list.dart';

class ConsultaFutureBuilder extends StatelessWidget {
  final Future<List<Colheita>> futureConsultas;

  const ConsultaFutureBuilder({required this.futureConsultas, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<List<Colheita>>(
              future: futureConsultas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return ColheitaList(colheitas: snapshot.data!);
                }
                return const LoadingPage();
              },
            );
  }
}