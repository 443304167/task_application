import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelperNotes {
  // static Future<Database> database() async {
  //   final dbPath = await sql.getDatabasesPath();

  //   return sql.openDatabase(path.join(dbPath, 'taskMaster_notes.db'),
  //       onCreate: (db, version) {
  //     return db.execute('''
  //          CREATE TABLE USERNOTE (
  //          id varchar(255),
  //          title varchar(255),
  //          info varchar(255),
  //          color varchar(255));
  //          ''');
  //   }, version: 1);
  // }
static Future<Database> database() async {
  final dbPath = await sql.getDatabasesPath();

  return sql.openDatabase(
    path.join(dbPath, 'taskMaster.db'),
    version: 2, // رفع النسخة إلى 2
    onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE USERTASK (
          id TEXT PRIMARY KEY,
          title TEXT,
          desc TEXT,
          stDate TEXT,
          image TEXT,
          priority TEXT,
          focusLevel TEXT,
          isDone INTEGER
        );
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute('ALTER TABLE USERTASK ADD COLUMN priority TEXT');
        db.execute('ALTER TABLE USERTASK ADD COLUMN focusLevel TEXT');
      }
    },
  );
}

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelperNotes.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelperNotes.database();
    return db.query(table);
  }

  static Future<void> delete(String id) async {
    final db = await DBHelperNotes.database();

    db.rawDelete('DELETE FROM USERNOTE WHERE id = ?', [id]);
  }

  static Future<void> update(
      String id, String title, String info, String color) async {
    final db = await DBHelperNotes.database();
    db.rawUpdate(
        'UPDATE USERNOTE SET title = ? , info = ? , color = ? WHERE id = ?',
        [title, info, color, id]);
  }

  static Future<void> close(String table) async {
    final db = await DBHelperNotes.database();
    db.rawDelete('DELETE FROM USERNOTE');
    db.close();
  }
}
