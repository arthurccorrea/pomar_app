import 'package:flutter/material.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/model/pomar.dart';

class CadastroPomar extends StatefulWidget {
  final Pomar pomar;
  const CadastroPomar({required this.pomar, Key? key}) : super(key: key);

  @override
  _CadastroPomarState createState() => _CadastroPomarState();
}

class _CadastroPomarState extends State<CadastroPomar> {
  final TextEditingController _descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GradientContainerBody(
          padding: const EdgeInsets.all(8),
          child: Form(
              child: Column(
            children: [
              DefaultInputField(
                  labelTextValue: "Descricao",
                  controller: _descricaoController,
                  onChanged: (value) {
                    widget.pomar.descricao = value;
                  }),
            ],
          ))),
    );
  }
}
