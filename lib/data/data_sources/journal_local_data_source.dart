import '../../shared/utils/helpers/database_helper.dart';
import '../models/journal_model.dart';

abstract class JournalLocalDataSource {
  Future<List<JournalModel>> getAllJournals();
  Future<void> addJournal(JournalModel model);
  Future<void> updateJournal(JournalModel model);
  Future<void> deleteJournal(int id);
}

class JournalLocalDataSourceImpl implements JournalLocalDataSource {
  final DatabaseHelper databaseHelper;
  JournalLocalDataSourceImpl(this.databaseHelper);

  // Lấy danh sách JournalModel từ DB
  @override
  Future<List<JournalModel>> getAllJournals() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('journals');
    return List.generate(maps.length, (i) => JournalModel.fromMap(maps[i]));
  }

  // Thêm mới JournalModel vào DB
  @override
  Future<void> addJournal(JournalModel model) async {
    final db = await databaseHelper.database;
    await db.insert('journals', model.toMap());
  }

  // Cập nhật JournalModel trong DB
  @override
  Future<void> updateJournal(JournalModel model) async {
    final db = await databaseHelper.database;
    await db.update(
      'journals',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // Xóa JournalModel khỏi DB
  @override
  Future<void> deleteJournal(int id) async {
    final db = await databaseHelper.database;
    await db.delete('journals', where: 'id = ?', whereArgs: [id]);
  }
}
