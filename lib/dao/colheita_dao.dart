import 'dart:developer';

import 'package:pomar_app/dao/dao.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:sqflite/sqflite.dart';

class ColheitaDao extends Dao {
  final String databaseName = "COLHEITA";

  Future<Colheita> save(Colheita colheita) async {
    final database = await openDatabaseConnection();
    log("Salvando ${colheita.toString()}");
    int codigo = await database.insert(
      databaseName,
      colheita.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return codigo == 0 ? Colheita() : await findByCodigo(codigo);
  }

  Future<Colheita> update(Colheita colheita) async {
    final database = await openDatabaseConnection();

    int codigo = await database.update(databaseName, colheita.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "CODIGO = ?",
        whereArgs: [colheita.codigo]);
    return codigo == 0 ? Colheita() : await findByCodigo(codigo);
  }

  Future<bool> delete(Colheita colheita) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database
        .delete(databaseName, where: "CODIGO=?", whereArgs: [colheita.codigo]);
    return linhasAfetadas > 0;
  }

  Future<List<Colheita>> list() async {
    final database = await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.query(databaseName);

    List<Colheita> colheitas = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return colheitas;
  }

  Future<Colheita> findByCodigo(int codigo, {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(databaseName, where: "CODIGO=?", whereArgs: [codigo]);

    List<Colheita> colheita = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return colheita[0];
  }

  Colheita setValues(List<Map<String, Object?>> maps, int index) {
    return Colheita.fromMap({
      'codigo': maps[index]['CODIGO'],
      'arvoreCodigo': maps[index]['ARVORE_CODIGO'],
      'informacoes': maps[index]['INFORMACOES'],
      'data': maps[index]['DATA'],
      'pesoBruto': maps[index]['PESO_BRUTO'],
    });
  }
}
