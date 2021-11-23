import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/core/widgets/default_button.dart';
import 'package:pomar_app/core/widgets/default_input_field.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/dao/colheita_dao.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/pages/home/providers/pomar_list_provider.dart';
import 'package:provider/provider.dart';

class CadastroColheita extends StatefulWidget {
  final Colheita colheita;
  const CadastroColheita({required this.colheita, Key? key}) : super(key: key);

  @override
  CadastroColheitaState createState() => CadastroColheitaState();
}

class CadastroColheitaState extends State<CadastroColheita> {
  final Key _formKey = GlobalKey<FormState>();
  final TextEditingController _informacoesController = TextEditingController();
  final TextEditingController _pesoBrutoController = TextEditingController();
  DateTime? data;
  bool isNovo = false;

  @override
  void initState() {
    isNovo = widget.colheita.codigo == null || widget.colheita.codigo == 0;
    if (!isNovo) {
      _informacoesController.text = widget.colheita.informacoes;
      _pesoBrutoController.text = widget.colheita.pesoBruto.toStringAsFixed(2);
      data = widget.colheita.data;
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
                    labelTextValue: "Informações",
                    controller: _informacoesController,
                    onChanged: (value) {
                      widget.colheita.informacoes = value;
                    }),
                DefaultInputField(
                    labelTextValue: "Peso bruto",
                    controller: _pesoBrutoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    tipoTeclado: TextInputType.number,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        widget.colheita.pesoBruto = 0;
                      } else {
                        widget.colheita.pesoBruto = double.parse(value);
                      }
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
                )
              ],
            ),
          )),
    );
  }

  Future<void> save() async {
    ColheitaDao colheitaDao = ColheitaDao();
    Colheita colheita = isNovo
        ? await colheitaDao.save(widget.colheita)
        : await colheitaDao.update(widget.colheita);
    if (colheita.codigo != null && colheita.codigo != 0) {
      PomarListProvider pomarListProvider = Provider.of<PomarListProvider>(context, listen: false);
      if (isNovo) {
        widget.colheita.codigo = colheita.codigo;
        pomarListProvider.addColheita(colheita);
        PageUtil.successAlertDialog("Colheita cadastrada com sucesso!", context);
      } else {
        pomarListProvider.replaceColheita(colheita);
        PageUtil.successAlertDialog("Colheita alterada com sucesso!", context);
      }
    } else {
      PageUtil.failureAlertDialog(
          "Erro ao ${isNovo ? 'cadastrar' : 'alterar'} a colheita", context);
    }

    reloadInputComponents(colheita);
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

   void reloadInputComponents(Colheita colheita) {
    isNovo = colheita.codigo == null || colheita.codigo == 0;
    if (!isNovo) {
      setState(() {
        _informacoesController.text = colheita.informacoes;
        _pesoBrutoController.text = colheita.pesoBruto.toStringAsFixed(2);
        data = colheita.data;
      });
    }
  }
}
