import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/widgets/default_button.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/dao/colheita_dao.dart';
import 'package:pomar_app/model/colheita.dart';

class CadastroColheita extends StatefulWidget {
  final Colheita colheita;
  CadastroColheita({required this.colheita, Key? key}) : super(key: key);

  @override
  CadastroColheitaState createState() => CadastroColheitaState();
}

class CadastroColheitaState extends State<CadastroColheita> {
  Key _formKey = GlobalKey<FormState>();
  TextEditingController _informacoesController = TextEditingController();
  DateTime? data;
  bool isNovo = false;
  
  @override
  void initState() {
    isNovo = widget.colheita.codigo == null || widget.colheita.codigo == 0;
    if (!isNovo) {
      _informacoesController.text = widget.colheita.informacoes;
      data = widget.colheita.data;
    }
    
  }
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
                    labelTextValue: "Informações",
                    controller: _informacoesController,
                    onChanged: (value) {
                      widget.colheita.informacoes = value;
                    }),
                Padding(
                  padding: const EdgeInsets.only(
                      top: defaultVerticalPadding,
                      bottom: defaultVerticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        data == null
                            ? 'Escolha um data de colheita!'
                            : 'Data do colheita: ${DateFormat("dd/MM/yyyy").format(data!)}',
                        style: TextStyle(
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
                )
              ],
            ),
          )),
    );
  }

  Future<void> save() async {
    ColheitaDao colheitaDao = ColheitaDao();
    Colheita colheita;
    if (isNovo) {
       colheita = await colheitaDao.save(widget.colheita);
    } else {
      colheita = await colheitaDao.update(widget.colheita);
    }
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
        data = pickedDate;
        widget.colheita.data = pickedDate;
      });
    });
  }
}
