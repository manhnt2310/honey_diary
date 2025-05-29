import '../../shared/utils/helpers/database_helper.dart';
import '../models/anniversary_model.dart';

abstract class AnniversaryLocalDataSource {
  Future<List<AnniversaryModel>> getAllAnniversaries();
  Future<void> addAnniversary(AnniversaryModel model);
  Future<void> updateAnniversary(AnniversaryModel model);
  Future<void> deleteAnniversary(int id);
}

class AnniversaryLocalDataSourceImpl implements AnniversaryLocalDataSource {
  final DatabaseHelper databaseHelper;
  AnniversaryLocalDataSourceImpl(this.databaseHelper);

  // Lấy danh sách AnniversaryModel từ DB
  @override
  Future<List<AnniversaryModel>> getAllAnniversaries() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('anniversaries');
    return List.generate(maps.length, (i) => AnniversaryModel.fromMap(maps[i]));
  }

  // Thêm mới AnniversaryModel vào DB
  @override
  Future<void> addAnniversary(AnniversaryModel model) async {
    final db = await databaseHelper.database;
    await db.insert('anniversaries', model.toMap());
  }

  // Cập nhật AnniversaryModel trong DB
  @override
  Future<void> updateAnniversary(AnniversaryModel model) async {
    final db = await databaseHelper.database;
    await db.update(
      'anniversaries',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // Xóa AnniversaryModel khỏi DB
  @override
  Future<void> deleteAnniversary(int id) async {
    final db = await databaseHelper.database;
    await db.delete('anniversaries', where: 'id = ?', whereArgs: [id]);
  }
}
