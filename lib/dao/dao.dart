import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dao {
  Future<Database> openDatabaseConnection() async {
    WidgetsFlutterBinding.ensureInitialized();
    Database database = await openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'pomar_database.db'),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE POMAR(CODIGO INTEGER PRIMARY KEY NOT NULL, NOME TEXT NOT NULL, DESCRICAO TEXT NOT NULL DEFAULT \"\")");
      db.execute(
          "CREATE TABLE ESPECIE(CODIGO INTEGER PRIMARY KEY NOT NULL, DESCRICAO TEXT NOT NULL)");
      db.execute(
          "CREATE TABLE ARVORE(CODIGO INTEGER PRIMARY KEY NOT NULL, POMAR_CODIGO INTEGER, ESPECIE_CODIGO INTEGER, DESCRICAO TEXT NOT NULL, DATA_PLANTIO NUMERIC NOT NULL, FOREIGN KEY (POMAR_CODIGO) REFERENCES POMAR(CODIGO), FOREIGN KEY (ESPECIE_CODIGO) REFERENCES ESPECIE(CODIGO))");
      return db.execute(
          "CREATE TABLE COLHEITA(CODIGO INTEGER PRIMARY KEY NOT NULL, ARVORE_CODIGO INTEGER, INFORMACOES TEXT NOT NULL DEFAULT \"\", DATA NUMERIC NOT NULL, PESO_BRUTO NUMERIC NOT NULL, FOREIGN KEY (ARVORE_CODIGO) REFERENCES ARVORE(CODIGO))");
    }, version: 1);

    return database;
  }
}
