import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/widgets/default_button.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/dao/arvore_dao.dart';
import 'package:pomar_app/model/arvore.dart';

class CadastroArvore extends StatefulWidget {
  final Arvore arvore;
  CadastroArvore({required this.arvore, Key? key}) : super(key: key);

  @override
  _CadastroArvoreState createState() => _CadastroArvoreState();
}

class _CadastroArvoreState extends State<CadastroArvore> {
  Key _formKey = GlobalKey<FormState>();
  TextEditingController _descricaoController = TextEditingController();
  DateTime? dataDePlantio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GradientContainerBody(
          padding: EdgeInsets.all(8),
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
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      DefaultButton('Escolher data', Colors.white, Colors.green,
                          onPressed: _pickDateDialog)
                    ],
                  ),
                ),
                DefaultButton(
                  "Cadastrar",
                  Colors.white,
                  Colors.green,
                  onPressed: () async {
                    ArvoreDao arvoreDao = ArvoreDao();
                    Arvore arvore = await arvoreDao.save(widget.arvore);
                  },
                )
              ],
            ),
          )),
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
}
