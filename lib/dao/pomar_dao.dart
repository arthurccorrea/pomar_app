import 'dart:developer';

import 'package:pomar_app/dao/arvore_dao.dart';
import 'package:pomar_app/dao/dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:sqflite/sqflite.dart';

class PomarDao extends Dao {
  final String databaseName = "POMAR";

  Future<Pomar> save(Pomar pomar) async {
    final database = await openDatabaseConnection();
    log("Salvando ${pomar.toString()}");
    int codigo = await database.insert(
      databaseName,
      pomar.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (codigo != 0) {
      log("Pomar salvo");
    }
    return codigo == 0 ? Pomar() : await findByCodigo(codigo);
  }

  Future<Pomar> update(Pomar pomar) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database.update(databaseName, pomar.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "CODIGO = ?",
        whereArgs: [pomar.codigo]);
    return linhasAfetadas == 0 ? Pomar() : await findByCodigo(pomar.codigo!);
  }

  Future<bool> delete(Pomar pomar) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database
        .delete(databaseName, where: "CODIGO=?", whereArgs: [pomar.codigo]);
    return linhasAfetadas > 0;
  }

  Future<List<Pomar>> list() async {
    final database = await openDatabaseConnection();
    log("Listando pomares");
    List<Map<String, Object?>> maps = await database.query(databaseName);

    List<Pomar> pomares = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    ArvoreDao arvoreDao = ArvoreDao();
    for (Pomar pomar in pomares) {
      List<Arvore> arvores = await arvoreDao.findByPomar(pomar.codigo!);
      if (arvores.isNotEmpty) {
        pomar.arvores = arvores;
      }
    }

    return pomares;
  }

  Future<Pomar> findByCodigo(int codigo, {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(databaseName, where: "CODIGO=?", whereArgs: [codigo]);

    List<Pomar> pomares = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });
    ArvoreDao arvoreDao = ArvoreDao();
    Pomar pomar = pomares[0];
    List<Arvore> arvores = await arvoreDao.findByPomar(codigo);
    pomar.arvores = arvores;

    return pomar;
  }

  Pomar setValues(List<Map<String, Object?>> maps, int index) {
    return Pomar.fromMap({
      'codigo': maps[index]['CODIGO'],
      'nome': maps[index]['NOME'],
      'descricao': maps[index]['DESCRICAO'],
    });
  }
}
