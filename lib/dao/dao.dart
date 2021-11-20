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
          "CREATE TABLE POMAR(CODIGO INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT, NOME VARCHAR(255) NOT NULL, DESCRICAO VARCHAR(255) NOT NULL DEFAULT \"\"");
      db.execute(
          "CREATE TABLE ARVORE(CODIGO INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT, POMAR_CODIGO INTEGER ADD CONSTRAINT FOREIGN KEY `ARVORE_POMAR_FK` REFERENCES POMAR(CODIGO), ESPECIE_CODIGO INTEGER ADD CONSTRAINT FOREIGN KEY `ARVORE_ESPECIE_FK` REFERENCES ESPECIE(CODIGO), DESCRICAO VARCHAR(255) NOT NULL, DATA_PLANTIO TIMESTAMP NOT NULL)");
      db.execute(
          "CREATE TABLE ESPECIE(CODIGO INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT, DESCRICAO VARCHAR(255) NOT NULL");
      return db.execute(
          "CREATE TABLE COLEHITA CODIGO INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT, ARVORE_CODIGO INTEGER ADD CONSTRAINT FOREIGN KEY `COLHEITA_ARVORE_FK` REFERENCES ARVORE(CODIGO), INFORMACOES MEDIUMTEXT NOT NULL DEFAULT \"\", DATA TIMESTAMP NOT NULL, PESO_BRUTO DECIMAL(9,2) NOT NULL");
    }, version: 1);

    return database;
  }
}
