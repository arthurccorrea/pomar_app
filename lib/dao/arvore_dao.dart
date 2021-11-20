import 'dart:developer';

import 'package:pomar_app/dao/dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:sqflite/sqflite.dart';

class ArvoreDao extends Dao {
  final String databaseName = "ARVORE";

  Future<Arvore> save(Arvore arvore) async {
    final database = await openDatabaseConnection();
    log("Salvando ${arvore.toString()}");
    int codigo = await database.insert(
      databaseName,
      arvore.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return codigo == 0 ? Arvore() : await findByCodigo(codigo);
  }

  Future<Arvore> update(Arvore arvore) async {
    final database = await openDatabaseConnection();

    int codigo = await database.update(databaseName, arvore.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "CODIGO = ?",
        whereArgs: [arvore.codigo]);
    return codigo == 0 ? Arvore() : await findByCodigo(codigo);
  }

  Future<bool> delete(Arvore arvore) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database
        .delete(databaseName, where: "CODIGO=?", whereArgs: [arvore.codigo]);
    return linhasAfetadas > 0;
  }

  Future<List<Arvore>> list() async {
    final database = await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.query(databaseName);

    List<Arvore> arvores = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return arvores;
  }

  Future<Arvore> findByCodigo(int codigo, {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(databaseName, where: "CODIGO=?", whereArgs: [codigo]);

    List<Arvore> arvores = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return arvores[0];
  }

  Future<List<Arvore>> findByPomar(int pomarCodigo,
      {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(databaseName, where: "POMAR_CODIGO=?", whereArgs: [pomarCodigo]);

    List<Arvore> arvores = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return arvores;
  }

  Arvore setValues(List<Map<String, Object?>> maps, int index) {
    return Arvore.fromMap({
      'codigo': maps[index]['CODIGO'],
      'pomarCodigo': maps[index]['POMAR_CODIGO'],
      'especieCodigo': maps[index]['ESPECIE_CODIGO'],
      'descricao': maps[index]['DESCRICAO'],
      'dataPlantio': maps[index]['DATA_PLANTIO'],
    });
  }
}
