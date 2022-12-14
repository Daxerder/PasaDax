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

class MovimientoDBTren {
  static Database? _database;
  static final MovimientoDBTren db = MovimientoDBTren._();

  MovimientoDBTren._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    Directory documento = await getApplicationDocumentsDirectory();
    final path = join(documento.path, 'Tren.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(''' CREATE TABLE Movimiento(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            opcion TEXT,
            monto REAL
          )''');
    });
  }

  Future<int?> nuevo(Movimiento movimiento) async {
    final db = await database;
    final resp = await db?.insert('Movimiento', movimiento.toJson());
    return resp;
  }

  Future<List<Movimiento>> getMovimiento() async {
    final db = await database;
    final resp = await db?.query('Movimiento');
    List<Movimiento> lista = resp!.map((e) => Movimiento.fromJson(e)).toList();

    if (lista.isNotEmpty) {
      return lista;
    } else {
      return [];
    }
  }

  Future<int?> eliminar(int id) async {
    final db = await database;
    final resp = await db?.delete('Movimiento', where: 'id=?', whereArgs: [id]);
    return resp;
  }
}

class MovimientoDBMetro {
  static Database? _database;
  static final MovimientoDBMetro db = MovimientoDBMetro._();

  MovimientoDBMetro._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    Directory documento = await getApplicationDocumentsDirectory();
    final path = join(documento.path, 'Metropolitano.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(''' CREATE TABLE Movimiento(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            opcion TEXT,
            monto REAL
          )''');
    });
  }

  Future<int?> nuevo(Movimiento movimiento) async {
    final db = await database;
    final resp = await db?.insert('Movimiento', movimiento.toJson());
    return resp;
  }

  Future<List<Movimiento>> getMovimiento() async {
    final db = await database;
    final resp = await db?.query('Movimiento');
    List<Movimiento> lista = resp!.map((e) => Movimiento.fromJson(e)).toList();

    if (lista.isNotEmpty) {
      return lista;
    } else {
      return [];
    }
  }

  Future<int?> eliminar(int id) async {
    final db = await database;
    final resp = await db?.delete('Movimiento', where: 'id=?', whereArgs: [id]);
    return resp;
  }
}
