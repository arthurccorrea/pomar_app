class Colheita {
  int codigo = 0;
  int arvoreCodigo = 0;
  String informacoes = "";
  DateTime? data;

  /// Gramas
  double pesoBruto = 0;

  Colheita();

  Colheita.fromMap(Map<String, dynamic> colheitaMap) {
    codigo = colheitaMap['codigo'];
    arvoreCodigo = colheitaMap['arvoreCodigo'];
    informacoes = colheitaMap['informacoes'];
    data = colheitaMap['data'];
  }

  Map<String, dynamic> toMap() {
    return {
      'CODIGO': codigo,
      'ARVORE_CODIGO': arvoreCodigo,
      'INFORMACOES': informacoes,
      'DATA': data
    };
  }

  @override
  String toString() {
    return "codigo: $codigo, arvoreCodigo: $arvoreCodigo, informacoes: $informacoes, data: $data, pesoBruto: $pesoBruto";
  }
}
