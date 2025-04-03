import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('anniversaries.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final docDir = await getApplicationDocumentsDirectory();
    final path = join(docDir.path, fileName);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      //onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE anniversaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date INTEGER,
        imagePaths TEXT,  -- Lưu danh sách ảnh dưới dạng chuỗi (ví dụ: đường dẫn phân cách dấu phẩy)
        content TEXT
      )
    ''');
  }

  // Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 2) {
  //     await db.execute('ALTER TABLE anniversaries ADD COLUMN content TEXT');
  //   }
  //   if (oldVersion < 3) {
  //     await db.execute('ALTER TABLE anniversaries ADD COLUMN imagePaths TEXT');
  //   }
  // }
}
