
import 'package:flutter_application_2/models/tarefa.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class Database {
  static Future<sqlite.Database> _getDB() async {
    final databasePath = await sqlite.getDatabasesPath();
    final arqBD = path.join(databasePath, 'tarefa.db');

    return sqlite.openDatabase(
      arqBD,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Tarefa(
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo        TEXT    NOT NULL,
            descricao     TEXT    NOT NULL,
            data_prevista TEXT    NOT NULL,
            importante    INTEGER NOT NULL DEFAULT 0,
            realizada     INTEGER NOT NULL DEFAULT 0,
            categoria     TEXT    NOT NULL DEFAULT 'Geral'
          )
        ''');
      },
    );
  }

  static Future<int> insert(Tarefa tarefa) async {
    final db = await _getDB();
    return await db.insert(
      Tarefa.tableName,
      tarefa.toMap(),
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> list(String table) async {
    final db = await _getDB();
    return db.query(table);
  }

  static Future<int> update(Tarefa tarefa) async {
    final db = await _getDB();
    return await db.update(
      Tarefa.tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> delete(String table, int id) async {
    final db = await _getDB();
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<Tarefa?> getProxima() async {
    final db = await _getDB();
    final hoje = DateTime.now().toIso8601String().substring(0, 10);
    final rows = await db.query(
      Tarefa.tableName,
      where: 'realizada = 0 AND data_prevista >= ?',
      whereArgs: [hoje],
      orderBy: 'data_prevista ASC',
      limit: 1,
    );
    return rows.isEmpty ? null : Tarefa.fromMap(rows.first);
  }
}
