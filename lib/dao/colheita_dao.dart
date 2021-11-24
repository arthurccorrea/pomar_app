import 'dart:developer';

import 'package:pomar_app/dao/arvore_dao.dart';
import 'package:pomar_app/dao/dao.dart';
import 'package:pomar_app/model/arvore.dart';
import 'package:pomar_app/model/colheita.dart';
import 'package:sqflite/sqflite.dart';

class ColheitaDao extends Dao {
  static String tableName = "COLHEITA";
  final String tableColumns =
      "$tableName.CODIGO, $tableName.ARVORE_CODIGO, $tableName.INFORMACOES, $tableName.DATA, $tableName.PESO_BRUTO";

  Future<Colheita> save(Colheita colheita) async {
    final database = await openDatabaseConnection();
    log("Salvando ${colheita.toString()}");
    int codigo = await database.insert(
      tableName,
      colheita.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return codigo == 0 ? Colheita() : await findByCodigo(codigo);
  }

  Future<Colheita> update(Colheita colheita) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database.update(tableName, colheita.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: "CODIGO = ?",
        whereArgs: [colheita.codigo]);
    return linhasAfetadas == 0
        ? Colheita()
        : await findByCodigo(colheita.codigo!);
  }

  Future<bool> delete(Colheita colheita) async {
    final database = await openDatabaseConnection();

    int linhasAfetadas = await database
        .delete(tableName, where: "CODIGO=?", whereArgs: [colheita.codigo]);
    return linhasAfetadas > 0;
  }

  Future<List<Colheita>> list() async {
    final database = await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.query(tableName);

    List<Colheita> colheitas = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return colheitas;
  }

  Future<Colheita> findByCodigo(int codigo, {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps =
        await database.query(tableName, where: "CODIGO=?", whereArgs: [codigo]);

    List<Colheita> colheita = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    return colheita[0];
  }

  Future<List<Colheita>> findByArvore(int arvoreCodigo,
      {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database
        .query(tableName, where: "ARVORE_CODIGO=?", whereArgs: [arvoreCodigo]);

    List<Colheita> colheitas = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    for (Colheita colheita in colheitas) {
      complementaColheita(colheita);
    }

    return colheitas;
  }

  Future<List<Colheita>> findColheitasByPomar(int pomarCodigo,
      {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.rawQuery(
        "SELECT $tableColumns FROM $tableName INNER JOIN ARVORE ON $tableName.ARVORE_CODIGO = ARVORE.CODIGO INNER JOIN POMAR ON ARVORE.POMAR_CODIGO = POMAR.CODIGO WHERE POMAR.CODIGO=?",
        [pomarCodigo]);
    List<Colheita> colheitas = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    for (Colheita colheita in colheitas) {
      complementaColheita(colheita);
    }

    return colheitas;
  }

  Future<List<Colheita>> findColheitasByEspecie(int especieCodigo,
      {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.rawQuery(
        "SELECT $tableColumns FROM $tableName INNER JOIN ARVORE ON $tableName.ARVORE_CODIGO = ARVORE.CODIGO WHERE ARVORE.ESPECIE_CODIGO=?",
        [especieCodigo]);
    List<Colheita> colheitas = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    for (Colheita colheita in colheitas) {
      complementaColheita(colheita);
    }

    return colheitas;
  }

  Future<List<Colheita>> findColheitaByData(DateTime dataInicio, DateTime dataTermino, {Database? database}) async {
    database ??= await openDatabaseConnection();

    List<Map<String, Object?>> maps = await database.query(tableName, where: "DATA BETWEEN ? AND ?", whereArgs: [dataInicio.millisecondsSinceEpoch, dataTermino.millisecondsSinceEpoch]);
    List<Colheita> colheitas = List.generate(maps.length, (index) {
      return setValues(maps, index);
    });

    for (Colheita colheita in colheitas) {
      complementaColheita(colheita);
    }

    return colheitas;
  }

  Future<void> complementaColheita(Colheita colheita) async {
    ArvoreDao arvoreDao = ArvoreDao();
    Arvore arvore = await arvoreDao.findByCodigo(colheita.arvoreCodigo);
    colheita.arvore = arvore;
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
