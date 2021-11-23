import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/core/widgets/default_button.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/dao/arvore_dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/colheita/cadastro_colheita.dart';
import 'package:pomar_app/pages/home/providers/pomar_list_provider.dart';
import 'package:provider/provider.dart';

class CadastroArvore extends StatefulWidget {
  final Arvore arvore;
  const CadastroArvore({required this.arvore, Key? key}) : super(key: key);

  @override
  _CadastroArvoreState createState() => _CadastroArvoreState();
}

class _CadastroArvoreState extends State<CadastroArvore> {
  final Key _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime? dataDePlantio;
  bool isNovo = false;

  @override
  void initState() {
    isNovo = widget.arvore.codigo == null || widget.arvore.codigo == 0;
    if (!isNovo) {
      _descricaoController.text = widget.arvore.descricao;
      dataDePlantio = widget.arvore.dataPlantio;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GradientContainerBody(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DefaultInputField(
                    labelTextValue: "Descricao",
                    controller: _descricaoController,
                    onChanged: (value) {
                      widget.arvore.descricao = value;
                    }),
                Padding(
                  padding: const EdgeInsets.only(
                      top: defaultVerticalPadding,
                      bottom: defaultVerticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        dataDePlantio == null
                            ? 'Escolha um data de plantio!'
                            : 'Data do plantio: ${DateFormat("dd/MM/yyyy").format(dataDePlantio!)}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      DefaultButton('Escolher data', Colors.white, Colors.green,
                          onPressed: _pickDateDialog)
                    ],
                  ),
                ),
                DefaultButton(
                  isNovo ? "Cadastrar" : "Alterar",
                  Colors.white,
                  Colors.green,
                  onPressed: () async {
                    await save();
                  },
                ),
                if (!isNovo)
                  Column(
                    children: [
                      PageUtil.divider(context),
                      const Text("Colheitas",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Consumer<PomarListProvider>(
                        builder: (context, value, child) {
                          Pomar pomar = value.pomares
                              .where(
                                  (p) => p.codigo == widget.arvore.pomarCodigo)
                              .first;
                          Arvore arvore = pomar.arvores
                              .where((a) => a.codigo == widget.arvore.codigo)
                              .first;
                          return Padding(
                              padding:
                                  const EdgeInsets.only(top: defaultVerticalPadding),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: defaultHorizontalPadding,
                                  mainAxisSpacing: defaultHorizontalPadding,
                                ),
                                itemCount: arvore.colheitas.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    PageUtil.navigate(
                                        CadastroColheita(
                                            colheita: arvore.colheitas[index]),
                                        context);
                                  },
                                  child: Card(
                                    child: Center(
                                      child: Text(
                                        arvore.colheitas[index].informacoes,
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ],
                  ),
              ],
            ),
          )),
      floatingActionButton: !isNovo
          ? FloatingActionButton(
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "images/harvest.png",
                        scale: 12,
                      )),
                  const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.add,
                        size: 30,
                      )),
                ],
              ),
              backgroundColor: Colors.green,
              tooltip:
                  "Colheita\nIcone por\nhttps://www.flaticon.com/authors/maxicons",
              onPressed: () {
                Colheita colheita = Colheita();
                colheita.arvoreCodigo = widget.arvore.codigo!;
                PageUtil.navigate(
                    CadastroColheita(colheita: colheita), context);
              })
          : null,
    );
  }

  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        dataDePlantio = pickedDate;
        widget.arvore.dataPlantio = pickedDate;
      });
    });
  }

  Future<void> save() async {
    ArvoreDao arvoreDao = ArvoreDao();
    Arvore arvore = isNovo
        ? await arvoreDao.save(widget.arvore)
        : await arvoreDao.update(widget.arvore);
    if (arvore.codigo != null && arvore.codigo != 0) {
      PomarListProvider pomarListProvider =
          Provider.of<PomarListProvider>(context, listen: false);
      if (isNovo) {
        pomarListProvider.addArvore(arvore);
        widget.arvore.codigo = arvore.codigo;
        PageUtil.successAlertDialog("Arvore cadastrada com sucesso!", context);
      } else {
        pomarListProvider.replaceArvore(arvore);
        PageUtil.successAlertDialog("Arvore alterada com sucesso!", context);
      }
    } else {
      PageUtil.failureAlertDialog(
          "Erro ao ${isNovo ? 'cadastrar' : 'alterar'} a arvore", context);
    }
    reloadInputComponents(arvore);
  }

  void reloadInputComponents(Arvore arvore) {
    isNovo = arvore.codigo == null || arvore.codigo == 0;
    if (!isNovo) {
      setState(() {
        _descricaoController.text = arvore.descricao;
        dataDePlantio = arvore.dataPlantio;
      });
    }
  }
}
