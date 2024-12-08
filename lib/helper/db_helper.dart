// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqlite_api.dart';
// import 'package:path/path.dart' as path;

//  class DBHelper {

// static Future<Database> database() async {
//   final dbPath = await sql.getDatabasesPath();

//   return sql.openDatabase(
//     path.join(dbPath, 'taskMaster.db'),
//     version: 1, // أو النسخة الحالية لقاعدة البيانات
//     onCreate: (db, version) async {
//       await db.execute('''
//         CREATE TABLE USERTASK (
//           id TEXT PRIMARY KEY,
//           title TEXT,
//           desc TEXT,
//           stDate TEXT,
//           image TEXT,
//           priority TEXT,
//           focusLevel TEXT,
//           isDone INTEGER
//         );
//       ''');

//       // إضافة إنشاء الجدول USERNOTE
//       await db.execute('''
//         CREATE TABLE USERNOTE (
//           id TEXT PRIMARY KEY,
//           title TEXT,
//           info TEXT,
//           color TEXT
//         );
//       ''');
//     },
//   );
// }

  
// // }

// void resetDatabase() async {
//   final dbPath = await sql.getDatabasesPath();
//   await sql.deleteDatabase(path.join(dbPath, 'taskMaster.db'));
//   print('Database reset successfully.');
// }

// static Future<void> insert(String table, Map<String, dynamic> data) async {
//   final db = await DBHelper.database();
//   db.insert(
//     table,
//     data,
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

  // static Future<void> insert(String table, Map<String, dynamic> data) async {
  //   final db = await DBHelper.database();
  //   db.insert(
  //     table,
  //     data,
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

// static Future<List<Map<String, dynamic>>> getData(String table) async {
//   final db = await DBHelper.database();
//   return db.query(table);
// }

//   // static Future<List<Map<String, dynamic>>> getData(String table) async {
//   //   final db = await DBHelper.database();
//   //   return db.query(table);
//   // }

//   static Future<void> delete(String id) async {
//     final db = await DBHelper.database();

//     db.rawDelete('DELETE FROM USERTASK WHERE id = ?', [id]);
//   }

//   static Future<void> update(String id, int isDone) async {
//     final db = await DBHelper.database();
//     db.rawUpdate('UPDATE USERTASK SET isDone = ? WHERE id = ?', [isDone, id]);
//   }

//   static Future<void> close(String table) async {
//     final db = await DBHelper.database();
//     db.rawDelete('DELETE FROM USERTASK');
//     db.close();
//   }
// }
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

 class DBHelper {

static Future<Database> database() async {
  final dbPath = await sql.getDatabasesPath();
  //  await sql.deleteDatabase(path.join(dbPath, 'taskMaster.db'));
  // print('Database reset successfully.');
  
  return sql.openDatabase(
    path.join(dbPath, 'taskMaster.db'),
    
    

    version: 1, // أو النسخة الحالية لقاعدة البيانات
    onCreate: (db, version) async {
      await db.execute('''
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
  await _insertDefaultTasks(db);
         print("data inserted");
      // إضافة إنشاء الجدول USERNOTE
      await db.execute('''
        CREATE TABLE USERNOTE (
          id TEXT PRIMARY KEY,
          title TEXT,
          info TEXT,
          color TEXT
        );
      ''');
      // إدخال المهام الافتراضية
      //  _insertDefaultTasks(db);
      //  print("data inserted");
    },
  );
}

  


static Future<void> insert(String table, Map<String, dynamic> data) async {
  final db = await DBHelper.database();
  db.insert(
    table,
    data,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}



static Future<List<Map<String, dynamic>>> getData(String table) async {
  final db = await DBHelper.database();
  return db.query(table);
}

  // static Future<List<Map<String, dynamic>>> getData(String table) async {
  //   final db = await DBHelper.database();
  //   return db.query(table);
  // }

  static Future<void> delete(String id) async {
    final db = await DBHelper.database();

    db.rawDelete('DELETE FROM USERTASK WHERE id = ?', [id]);
  }

  static Future<void> update(String id, int isDone) async {
    final db = await DBHelper.database();
    db.rawUpdate('UPDATE USERTASK SET isDone = ? WHERE id = ?', [isDone, id]);
  }

  static Future<void> close(String table) async {
    final db = await DBHelper.database();
    db.rawDelete('DELETE FROM USERTASK');
    db.close();
  }

  // دالة لإدخال المهام الافتراضية
  static Future<void> _insertDefaultTasks(Database db) async {
    final List<Map<String, dynamic>> defaultTasks = [
      {'id': '1', 'title': 'Study Math', 'desc': '', 'stDate': '', 'image': '', 'priority': 'High', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '2', 'title': 'Do Yoga', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Medium', 'focusLevel': 'A little focused', 'isDone': 0},
      {'id': '3', 'title': 'Watch TV', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Low', 'focusLevel': 'Not focused', 'isDone': 0},
      {'id': '4', 'title': 'Complete Project', 'desc': '', 'stDate': '', 'image': '', 'priority': 'High', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '5', 'title': 'Read a Book', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Medium', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '6', 'title': 'Clean the House', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Low', 'focusLevel': 'A little focused', 'isDone': 0},
      {'id': '7', 'title': 'Write an Essay', 'desc': '', 'stDate': '', 'image': '', 'priority': 'High', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '8', 'title': 'Take a Walk', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Low', 'focusLevel': 'Not focused', 'isDone': 0},
      {'id': '9', 'title': 'Plan the Week', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Medium', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '10', 'title': 'Meditate', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Low', 'focusLevel': 'A little focused', 'isDone': 0},
      {'id': '11', 'title': 'Prepare for Presentation', 'desc': '', 'stDate': '', 'image': '', 'priority': 'High', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '12', 'title': 'Organize Files', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Medium', 'focusLevel': 'A little focused', 'isDone': 0},
      {'id': '13', 'title': 'Listen to a Podcast', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Low', 'focusLevel': 'Not focused', 'isDone': 0},
      {'id': '14', 'title': 'Learn a New Skill', 'desc': '', 'stDate': '', 'image': '', 'priority': 'High', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '15', 'title': 'Call a Friend', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Low', 'focusLevel': 'Not focused', 'isDone': 0},
      {'id': '16', 'title': 'Write a Journal Entry', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Medium', 'focusLevel': 'A little focused', 'isDone': 0},
      {'id': '17', 'title': 'Cook Dinner', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Medium', 'focusLevel': 'A little focused', 'isDone': 0},
      {'id': '18', 'title': 'Fix the Bike', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Low', 'focusLevel': 'Not focused', 'isDone': 0},
      {'id': '19', 'title': 'Prepare Meeting Notes', 'desc': '', 'stDate': '', 'image': '', 'priority': 'High', 'focusLevel': 'Focused', 'isDone': 0},
      {'id': '20', 'title': 'Exercise at Gym', 'desc': '', 'stDate': '', 'image': '', 'priority': 'Medium', 'focusLevel': 'Focused', 'isDone': 0},
    ];

    for (var task in defaultTasks) {
      await db.insert('USERTASK', task);
    }
  }




}
