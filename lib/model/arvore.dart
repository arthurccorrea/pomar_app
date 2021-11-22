import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/model/especie.dart';
import 'package:pomar_app/model/pomar.dart';

class Arvore {
  int? codigo;
  int pomarCodigo = 0;
  int especieCodigo = 0;
  String descricao = "";
  DateTime? dataPlantio;

  Pomar? pomar;
  Especie? especie;
  List<Colheita> colheitas = [];

  Arvore();

  Arvore.fromMap(Map<String, dynamic> arvoreMap) {
    codigo = arvoreMap['codigo'];
    pomarCodigo = arvoreMap['pomarCodigo'];
    especieCodigo = arvoreMap['especieCodigo'];
    descricao = arvoreMap['descricao'];
    dataPlantio = DateTime.fromMillisecondsSinceEpoch(arvoreMap['dataPlantio']);
  }

  Map<String, dynamic> toMap() {
    return {
      'CODIGO': codigo,
      'POMAR_CODIGO': pomarCodigo,
      'ESPECIE_CODIGO': especieCodigo,
      'DESCRICAO': descricao,
      'DATA_PLANTIO': dataPlantio!.millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return "codigo: $codigo, pomarCodigo: $pomarCodigo, especieCodigo: $especieCodigo, descricao: $descricao, dataPlantio: $dataPlantio";
  }
}
