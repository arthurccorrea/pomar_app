import 'dart:developer';

import 'package:pomar_app/dao/colheita_dao.dart';
import 'package:pomar_app/dao/dao.dart';
import 'package:pomar_app/dao/pomar_dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:sqflite/sqflite.dart';

class ArvoreDao extends Dao {
  final String tableName = "ARVORE";

  Future<Arvore> save(Arvore arvore) async {
    final database = await openDatabaseConnection();
    log("Salvando ${arvore.toString()}");
    int codigo = await database.insert(
      tableName,
      arvore.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return codigo == 0 ? Arvore() : await findByCodigo(codigo);
  }

  Future<Arvore> update(Arvore arvore) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database.update(tableName, arvore.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "CODIGO = ?",
        whereArgs: [arvore.codigo]);
    return linhasAfetadas == 0 ? Arvore() : await findByCodigo(arvore.codigo!);
  }

  Future<bool> delete(Arvore arvore) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database
        .delete(tableName, where: "CODIGO=?", whereArgs: [arvore.codigo]);
    return linhasAfetadas > 0;
  }

  Future<List<Arvore>> list() async {
    final database = await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.query(tableName);

    List<Arvore> arvores = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    PomarDao pomarDao = PomarDao();
    for (Arvore arvore in arvores) {
      Pomar pomar = await pomarDao.findByCodigo(arvore.pomarCodigo, database: database, comArvores: false);
      arvore.pomar = pomar;
    }

    return arvores;
  }

  Future<Arvore> findByCodigo(int codigo, {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(tableName, where: "CODIGO=?", whereArgs: [codigo]);

    List<Arvore> arvores = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return arvores[0];
  }

  Future<List<Arvore>> findByPomar(int pomarCodigo,
      {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(tableName, where: "POMAR_CODIGO=?", whereArgs: [pomarCodigo]);

    List<Arvore> arvores = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    ColheitaDao colheitaDao = ColheitaDao();
    for (Arvore arvore in arvores) {
      List<Colheita> colheitas = await colheitaDao.findByArvore(arvore.codigo!, database: database);
      if (colheitas.isNotEmpty) {
        arvore.colheitas = colheitas;
      }
    }

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
