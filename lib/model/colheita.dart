import 'package:pomar_app/model/arvore.dart';

class Colheita {
  int? codigo;
  int arvoreCodigo = 0;
  String informacoes = "";
  DateTime? data;

  /// Gramas
  double pesoBruto = 0;

  Arvore? arvore;

  Colheita();

  Colheita.fromMap(Map<String, dynamic> colheitaMap) {
    codigo = colheitaMap['codigo'];
    arvoreCodigo = colheitaMap['arvoreCodigo'];
    informacoes = colheitaMap['informacoes'];
    data = DateTime.fromMillisecondsSinceEpoch(colheitaMap['data']);
    pesoBruto = double.parse(colheitaMap['pesoBruto'].toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'CODIGO': codigo,
      'ARVORE_CODIGO': arvoreCodigo,
      'INFORMACOES': informacoes,
      'DATA': data!.millisecondsSinceEpoch,
      'PESO_BRUTO' : pesoBruto
    };
  }

  @override
  String toString() {
    return "codigo: $codigo, arvoreCodigo: $arvoreCodigo, informacoes: $informacoes, data: $data, pesoBruto: $pesoBruto";
  }
}
