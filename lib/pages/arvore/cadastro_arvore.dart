import 'package:flutter/material.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GradientContainerBody(
          child: Form(
        key: _formKey,
        child: ListView(
          children: [
            DefaultInputField(
                labelTextValue: "labelTextValue",
                controller: _descricaoController,
                onChanged: (value) {
                  widget.arvore.descricao = value;
                }),
            DatePickerDialog(
                initialDate: DateTime.now(),
                firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                lastDate: DateTime.now())
          ],
        ),
      )),
    );
  }
}
