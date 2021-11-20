class Especie {
  int? codigo;
  String descricao = "";

  Especie();

  Especie.fromMap(Map<String, dynamic> especieMap) {
    codigo = especieMap['codigo'];
    descricao = especieMap['descricao'];
  }

  Map<String, dynamic> toMap() {
    return {'CODIGO': codigo, 'DESCRICAO': descricao};
  }

  @override
  String toString() {
    return "Especie{codigo: $codigo, descricao: $descricao}";
  }
}
