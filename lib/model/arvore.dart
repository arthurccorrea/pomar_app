class Arvore {
  int codigo = 0;
  int pomarCodigo = 0;
  int especieCodigo = 0;
  String descricao = "";
  DateTime? dataPlantio;

  Arvore();

  Arvore.fromMap(Map<String, dynamic> arvoreMap) {
    codigo = arvoreMap['codigo'];
    pomarCodigo = arvoreMap['pomarCodigo'];
    especieCodigo = arvoreMap['especieCodigo'];
    descricao = arvoreMap['descricao'];
    dataPlantio = arvoreMap['dataPlatio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'CODIGO': codigo,
      'POMAR_CODIGO': pomarCodigo,
      'ESPECIE_CODIGO': especieCodigo,
      'DESCRICAO': descricao,
      'DATA_PLANTIO': dataPlantio
    };
  }

  @override
  String toString() {
    return "codigo: $codigo, pomarCodigo: $pomarCodigo, especieCodigo: $especieCodigo, descricao: $descricao, dataPlantio: $dataPlantio";
  }
}
