import 'dart:developer';

import 'package:pomar_app/dao/dao.dart';
import 'package:pomar_app/model/especie.dart';
import 'package:sqflite/sqflite.dart';

class EspecieDao extends Dao {
  final String databaseName = "ESPECIE";

  Future<Especie> save(Especie especie) async {
    final database = await openDatabaseConnection();
    log("Salvando ${especie.toString()}");
    int codigo = await database.insert(
      databaseName,
      especie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return codigo == 0 ? Especie() : await findByCodigo(codigo);
  }

  Future<Especie> update(Especie especie) async {
    final database = await openDatabaseConnection();

    int codigo = await database.update(databaseName, especie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "CODIGO = ?",
        whereArgs: [especie.codigo]);
    return codigo == 0 ? Especie() : await findByCodigo(codigo);
  }

  Future<bool> delete(Especie especie) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database
        .delete(databaseName, where: "CODIGO=?", whereArgs: [especie.codigo]);
    return linhasAfetadas > 0;
  }

  Future<List<Especie>> list() async {
    final database = await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.query(databaseName);

    List<Especie> especies = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return especies;
  }

  Future<Especie> findByCodigo(int codigo, {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(databaseName, where: "CODIGO=?", whereArgs: [codigo]);

    List<Especie> especies = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return especies[0];
  }

  Especie setValues(List<Map<String, Object?>> maps, int index) {
    return Especie.fromMap({
      'codigo': maps[index]['CODIGO'],
      'descricao': maps[index]['DESCRICAO'],
    });
  }
}
