import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Hàm trả về đối tượng Database (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('anniversaries.db');
    return _database!;
  }

  // Tạo và mở database
  Future<Database> _initDB(String fileName) async {
    // Lấy đường dẫn thư mục ứng dụng
    final docDir = await getApplicationDocumentsDirectory();
    final path = join(docDir.path, fileName);

    // Mở database với version = 2
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Tạo bảng (cho cài đặt lần đầu)
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE anniversaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        date INTEGER,
        imagePath TEXT,
        content TEXT
      )
    ''');
  }

  // Nâng cấp DB (cho cài đặt cũ đã có version 1)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Nếu version cũ < 2, thì ALTER TABLE để thêm cột content
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE anniversaries ADD COLUMN content TEXT');
    }
  }
}
