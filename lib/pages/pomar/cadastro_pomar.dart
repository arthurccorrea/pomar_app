import 'package:flutter/material.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/core/widgets/default_button.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/dao/pomar_dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/arvore/cadastro_arvore.dart';
import 'package:pomar_app/pages/arvore/selecionar_especie.dart';
import 'package:pomar_app/pages/home/providers/pomar_list_provider.dart';
import 'package:pomar_app/pages/pomar/providers/list_arvore_provider.dart';
import 'package:provider/provider.dart';

class CadastroPomar extends StatefulWidget {
  final Pomar pomar;
  const CadastroPomar({required this.pomar, Key? key}) : super(key: key);

  @override
  _CadastroPomarState createState() => _CadastroPomarState();
}

class _CadastroPomarState extends State<CadastroPomar> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final Key _formKey = GlobalKey<FormState>();
  bool isNovo = false;

  @override
  void initState() {
    isNovo = widget.pomar.codigo == null || widget.pomar.codigo == 0;
    if (!isNovo) {
      _nomeController.text = widget.pomar.nome;
      _descricaoController.text = widget.pomar.descricao;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider(
        create: (context) => ListArvoreProvider(),
        child: SingleChildScrollView(
          child: GradientContainerBody(
              padding: const EdgeInsets.all(8),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DefaultInputField(
                          labelTextValue: "Nome",
                          controller: _nomeController,
                          defaultValidation: true,
                          onChanged: (value) {
                            widget.pomar.nome = value;
                          }),
                      DefaultInputField(
                          labelTextValue: "Descricao",
                          controller: _descricaoController,
                          onChanged: (value) {
                            widget.pomar.descricao = value;
                          }),
                      const Padding(
                          padding:
                              EdgeInsets.only(top: defaultVerticalPadding)),
                      DefaultButton(
                        isNovo ? "Adicionar" : "Alterar",
                        Colors.white,
                        Colors.black,
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () async {
                          await save();
                        },
                      ),
                      if (!isNovo)
                        Column(
                          children: [
                            PageUtil.divider(context),
                            const Text("Arvores",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Consumer<PomarListProvider>(
                              builder: (context, value, _) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: defaultVerticalPadding),
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing:
                                          defaultHorizontalPadding,
                                      mainAxisSpacing: defaultHorizontalPadding,
                                    ),
                                    controller: ScrollController(),
                                    itemCount: value
                                        .getPomar(widget.pomar.codigo!)
                                        .arvores
                                        .length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                      onTap: () {
                                        PageUtil.navigate(
                                            CadastroArvore(
                                                arvore: value
                                                    .getPomar(
                                                        widget.pomar.codigo!)
                                                    .arvores[index]),
                                            context);
                                      },
                                      child: Card(
                                        child: Center(
                                          child: Text(
                                            value
                                                .getPomar(widget.pomar.codigo!)
                                                .arvores[index]
                                                .descricao,
                                            style:
                                                const TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                    ],
                  ))),
        ),
      ),
      floatingActionButton: !isNovo
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              tooltip: "Adicionar arvore",
              child: Stack(
                children: [
                  Align(
                    child: Image.asset(
                      "images/tree.png",
                      color: Colors.black,
                    ),
                    alignment: Alignment.center,
                  ),
                  const Align(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 40,
                    ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
              onPressed: () {
                Arvore arvore = Arvore();
                arvore.pomarCodigo = widget.pomar.codigo!;
                PageUtil.navigate(SelecionarEspecie(arvore: arvore), context);
              },
            )
          : null,
    );
  }

  void reloadInputComponents(Pomar pomar) {
    isNovo = pomar.codigo == null || pomar.codigo == 0;
    if (!isNovo) {
      _nomeController.text = pomar.nome;
      _descricaoController.text = pomar.descricao;
    }
  }

  Future<void> save() async {
    PomarDao pomarDao = PomarDao();
    Pomar pomar = isNovo
        ? await pomarDao.save(widget.pomar)
        : await pomarDao.update(widget.pomar);
    if (pomar.codigo != null && pomar.codigo != 0) {
      final pomarListProvider =
          Provider.of<PomarListProvider>(context, listen: false);
      if (isNovo) {
        pomarListProvider.addPomar(pomar);
        widget.pomar.codigo = pomar.codigo;
        PageUtil.successAlertDialog("Pomar cadastrado com sucesso!", context);
      } else {
        pomarListProvider.replacePomar(pomar);
        PageUtil.successAlertDialog("Pomar alterado com sucesso!", context);
      }
    } else {
      PageUtil.failureAlertDialog("Erro ao ${isNovo ? 'cadastrar' : 'alterar'} o pomar", context);
    }
    reloadInputComponents(pomar);
  }
}
