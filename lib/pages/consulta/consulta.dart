import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomar_app/core/cache/especie_cache.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/core/widgets/default_button.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';
import 'package:pomar_app/dao/arvore_dao.dart';
import 'package:pomar_app/dao/colheita_dao.dart';
import 'package:pomar_app/dao/pomar_dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/model/especie.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/consulta/widgets/consulta_future_builder.dart';

class Consulta extends StatefulWidget {
  const Consulta({Key? key}) : super(key: key);

  @override
  _ConsultaState createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  Future<List<Colheita>>? futureConsultas;
  _TipoConsulta? _tipoConsulta;
  Arvore? arvore;
  Pomar? pomar;
  Especie? especie;
  DateTime? dataInicio, dataTermino;
  List<Pomar> pomarList = [];
  List<Arvore> arvoreList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de colheitas"),
      ),
      body: GradientContainerBody(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            _tipoConsultaDropdown(),
            if (_tipoConsulta != null) filtroConsulta(),
            Padding(
              padding: const EdgeInsets.only(top: defaultVerticalPadding),
              child: Visibility(
                  visible: _tipoConsulta != null,
                  replacement: const Text("Por favor escolha o tipo da consulta",
                      textAlign: TextAlign.center),
                  child: DefaultButton(
                    "Consultar",
                    Colors.white,
                    Colors.green,
                    onPressed: () {
                      consultar();
                    },
                  )),
            ),
            if (futureConsultas != null)
              ConsultaFutureBuilder(futureConsultas: futureConsultas!)
          ],
        ),
      ),
    );
  }

  DropdownButton<_TipoConsulta> _tipoConsultaDropdown() {
    return DropdownButton<_TipoConsulta>(
      isExpanded: true,
      dropdownColor: Colors.green,
      value: _tipoConsulta,
      menuMaxHeight: MediaQuery.of(context).size.height * 0.71,
      hint: Align(
        alignment: Alignment.center,
        child: Text("Escolha o filtro da consulta",
            style: const TextStyle(fontSize: 15, color: Colors.white),
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)),
      ),
      iconSize: 50,
      iconEnabledColor: Colors.white,
      items: _TipoConsulta.values.map((t) {
        return DropdownMenuItem<_TipoConsulta>(
          value: t,
          child: Align(
              alignment: Alignment.center,
              child: Text(t.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3))),
        );
      }).toList(),
      onChanged: (_TipoConsulta? t) {
        setState(() {
          _tipoConsulta = t;
        });
      },
    );
  }

  Widget filtroConsulta() {
    switch (_tipoConsulta!) {
      case _TipoConsulta.ARVORE:
        return filtroArvoreDropDownFutureBuilder();
      case _TipoConsulta.POMAR:
        return filtroPomarDropDownFutureBuilder();
      case _TipoConsulta.ESPECIE:
        return filtroEspecieDropDownFutureBuilder();
      case _TipoConsulta.DATAS:
        return filtroDatasRow();
    }
  }

  Future<List<Arvore>> getArvores() async {
    if (arvoreList.isNotEmpty) {
      return arvoreList;
    }
    ArvoreDao arvoreDao = ArvoreDao();
    arvoreList = await arvoreDao.list();
    return arvoreList;
  
  }

  FutureBuilder<List<Arvore>> filtroArvoreDropDownFutureBuilder() {
    return FutureBuilder(
      future: getArvores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return filtroArvoreDropDown(snapshot.data!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  DropdownButton<Arvore> filtroArvoreDropDown(List<Arvore> arvores) {
    return DropdownButton<Arvore>(
      isExpanded: true,
      dropdownColor: Colors.green,
      value: arvore,
      menuMaxHeight: MediaQuery.of(context).size.height * 0.71,
      hint: Align(
        alignment: Alignment.center,
        child: Text("Escolha a arvore",
            style: const TextStyle(fontSize: 15, color: Colors.white),
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)),
      ),
      iconSize: 50,
      iconEnabledColor: Colors.white,
      items: arvores.map((a) {
        return DropdownMenuItem<Arvore>(
          value: a,
          child: Align(
              alignment: Alignment.center,
              child: Text("${a.descricao}, - ${a.pomar!.nome}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3))),
        );
      }).toList(),
      onChanged: (Arvore? a) {
        setState(() {
          arvore = a;
        });
      },
    );
  }

  Future<List<Pomar>> getPomares() async {
    if (pomarList.isNotEmpty) {
      return pomarList;
    }
    PomarDao pomarDao = PomarDao();
    pomarList = await pomarDao.list();
    setState(() {});
    return pomarList;
  }

  FutureBuilder<List<Pomar>> filtroPomarDropDownFutureBuilder() {
    return FutureBuilder<List<Pomar>>(
      future: getPomares(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return filtroPomarDropDown(snapshot.data!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  DropdownButton<Pomar> filtroPomarDropDown(List<Pomar> pomares) {
    return DropdownButton<Pomar>(
      isExpanded: true,
      dropdownColor: Colors.green,
      value: pomar,
      menuMaxHeight: MediaQuery.of(context).size.height * 0.71,
      hint: Align(
        alignment: Alignment.center,
        child: Text("Escolha o pomar",
            style: const TextStyle(fontSize: 15, color: Colors.white),
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)),
      ),
      iconSize: 50,
      iconEnabledColor: Colors.white,
      items: pomares.map((p) {
        return DropdownMenuItem<Pomar>(
          value: p,
          child: Align(
              alignment: Alignment.center,
              child: Text(p.descricao,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3))),
        );
      }).toList(),
      onChanged: (Pomar? p) {
        setState(() {
          pomar = p;
        });
      },
    );
  }

  FutureBuilder<List<Especie>> filtroEspecieDropDownFutureBuilder() {
    return FutureBuilder<List<Especie>>(
      future: EspecieCache.getEspecies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return filtroEspecieDropDown(snapshot.data!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  DropdownButton<Especie> filtroEspecieDropDown(List<Especie> especies) {
    return DropdownButton<Especie>(
      isExpanded: true,
      dropdownColor: Colors.green,
      value: especie,
      menuMaxHeight: MediaQuery.of(context).size.height * 0.71,
      hint: Align(
        alignment: Alignment.center,
        child: Text("Escolha a especie",
            style: const TextStyle(fontSize: 15, color: Colors.white),
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3)),
      ),
      iconSize: 50,
      iconEnabledColor: Colors.white,
      items: especies.map((e) {
        return DropdownMenuItem<Especie>(
          value: e,
          child: Align(
              alignment: Alignment.center,
              child: Text(e.descricao,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(1.0, 1.3))),
        );
      }).toList(),
      onChanged: (Especie? e) {
        setState(() {
          especie = e;
        });
      },
    );
  }

  Row filtroDatasRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DefaultButton(
            dataInicio == null
                ? "Definir inicio"
                : DateFormat("dd/MM/yyyy").format(dataInicio!),
            Colors.brown,
            Colors.white, onPressed: () {
          _pickDateDialog(inicio: true);
        }),
        DefaultButton(
            dataTermino == null
              ? "Definir termino"
                : DateFormat("dd/MM/yyyy").format(dataTermino!),
            Colors.brown,
            Colors.white, onPressed: () {
          _pickDateDialog(inicio: false);
        })
      ],
    );
  }

  void _pickDateDialog({required bool inicio}) {
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
        if (inicio) {
          dataInicio = pickedDate;
        } else {
          dataTermino = pickedDate;
        }
      });
    });
  }

  void consultar() {
    ColheitaDao colheitaDao = ColheitaDao();
    switch (_tipoConsulta!) {
      case _TipoConsulta.ARVORE:
        if (arvore == null) {
          PageUtil.warningAlertDialog(
              "Por favor, escolha a arvore da consulta", context);
          break;
        }
        setState(() {
          futureConsultas = colheitaDao.findByArvore(arvore!.codigo!);
        });
        break;
      case _TipoConsulta.POMAR:
        if (pomar == null) {
          PageUtil.warningAlertDialog(
              "Por favor, escolha o pomar da consulta", context);
          break;
        }
        setState(() {
          futureConsultas = colheitaDao.findColheitasByPomar(pomar!.codigo!);
        });
        break;
      case _TipoConsulta.ESPECIE:
        if (especie == null) {
          PageUtil.warningAlertDialog(
              "Por favor, escolha a especie da consulta", context);
          break;
        }
        setState(() {
          futureConsultas =
              colheitaDao.findColheitasByEspecie(especie!.codigo!);
        });
        break;
      case _TipoConsulta.DATAS:
        if (dataInicio == null || dataTermino == null) {
          PageUtil.warningAlertDialog(
              "Por favor, escolha as datas da consulta", context);
          break;
        }
        setState(() {
          futureConsultas =
              colheitaDao.findColheitaByData(dataInicio!, dataTermino!);
        });
        break;
    }
  }
}

enum _TipoConsulta {
  // ignore: constant_identifier_names
  ARVORE,
  // ignore: constant_identifier_names
  POMAR,
  // ignore: constant_identifier_names
  ESPECIE,
  // ignore: constant_identifier_names
  DATAS
}

extension _TipoConsultaExtension on _TipoConsulta {
  get name {
    switch (this) {
      case _TipoConsulta.ARVORE:
        return "Árvore";
      case _TipoConsulta.POMAR:
        return "Pomar";
      case _TipoConsulta.ESPECIE:
        return "Espécie";
      case _TipoConsulta.DATAS:
        return "Data da colheita";
    }
  }
}
