import 'dart:io';
import 'package:medio_pasaje/models/clases.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _database;
  static final DB db = DB._();

  DB._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    Directory documento = await getApplicationDocumentsDirectory();
    final path = join(documento.path, 'Saldo.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(''' CREATE TABLE Tarjetas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tarjeta TEXT,
            saldo REAL
          )''');
    });
  }

  Future<int?> nuevo(Tarjeta tarjeta) async {
    final db = await database;
    final resp = await db?.insert('Tarjetas', tarjeta.toJson());
    return resp;
  }

  Future<List<Tarjeta>> getTarjetas() async {
    final db = await database;
    final resp = await db?.query('Tarjetas');
    List<Tarjeta> lista = resp!.map((e) => Tarjeta.fromJson(e)).toList();

    if (lista.isNotEmpty) {
      return lista;
    } else {
      return [];
    }
  }

  Future<int?> modificarSaldo(Tarjeta tarjeta) async {
    final db = await database;
    final resp = await db?.update('Tarjetas', tarjeta.toJson(),
        where: 'id=?', whereArgs: [tarjeta.id]);
    return resp;
  }
}
