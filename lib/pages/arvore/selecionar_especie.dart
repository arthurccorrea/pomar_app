import 'package:flutter/material.dart';
import 'package:pomar_app/core/cache/especie_cache.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/core/widgets/default_button.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/core/widgets/loading_page.dart';
import 'package:pomar_app/dao/especie_dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/especie.dart';
import 'package:pomar_app/pages/arvore/cadastro_arvore.dart';

class SelecionarEspecie extends StatefulWidget {
  final Arvore arvore;
  SelecionarEspecie({required this.arvore, Key? key}) : super(key: key);

  @override
  _SelecionarEspecieState createState() => _SelecionarEspecieState();
}

class _SelecionarEspecieState extends State<SelecionarEspecie> {
  List<Especie> especies = [];
  TextEditingController _descricaoController = TextEditingController();
  Especie? especieAdd;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GradientContainerBody(
        child: FutureBuilder<List<Especie>>(
          future: EspecieCache.getEspecies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              especies = snapshot.data!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: defaultHorizontalPadding,
                  mainAxisSpacing: defaultHorizontalPadding,
                ),
                itemCount: especies.length + 1,
                itemBuilder: (context, index) {
                  if (index == especies.length) {
                    return GestureDetector(
                      onTap: () {
                        especieAdd = Especie();
                        showDialog(
                          context: context,
                          builder: (context) => adicionarEspecieDialog(context),
                        );
                      },
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.add), Text("Adicionar novo")],
                      )),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      widget.arvore.especie = especies[index];
                      widget.arvore.especieCodigo = especies[index].codigo!;
                      PageUtil.navigateReplacement(
                          CadastroArvore(arvore: widget.arvore), context);
                    },
                    child: Card(
                      child:
                          Center(child: Text("${especies[index].descricao}")),
                    ),
                  );
                },
              );
            }
            return LoadingPage();
          },
        ),
      ),
    );
  }

  AlertDialog adicionarEspecieDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green,
      content: DefaultInputField(
          labelTextValue: "Descrição",
          controller: _descricaoController,
          onChanged: (value) {
            especieAdd!.descricao = value;
          }),
      actions: [
        DefaultButton(
          "Adicionar",
          Colors.transparent,
          Colors.black,
          onPressed: () async {
            EspecieDao especieDao = EspecieDao();
            Especie especie = await especieDao.save(especieAdd!);
            setState(() {
              especies.add(especie);
            });
            EspecieCache.resetCache();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
