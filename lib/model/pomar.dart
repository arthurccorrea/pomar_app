import 'package:pomar_app/model/arvore.dart';

class Pomar {
  int codigo = 0;
  String nome = "";
  String descricao = "";
  List<Arvore> arvores = [];

  Pomar();

  Pomar.fromMap(Map<String, dynamic> pomarMap) {
    codigo = pomarMap['codigo'];
    nome = pomarMap['nome'];
    descricao = pomarMap['descricao'];
  }

  Map<String, dynamic> toMap() {
    return {'CODIGO': codigo, 'NOME': nome, 'DESCRICAO': descricao};
  }

  @override
  String toString() {
    String toStr =
        "Pomar{codigo: $codigo, nome: $nome, descricao: $descricao, arvores: [";
    for (var element in arvores) {
      toStr += element.toString() + ",";
    }
    toStr += "]}";
    return toStr;
  }
}
