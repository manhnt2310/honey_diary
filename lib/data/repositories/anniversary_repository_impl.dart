// data/repositories/anniversary_repository_impl.dart
import '../../domain/entities/anniversary.dart';
import '../../domain/repositories/anniversary_repository.dart';
import '../data_sources/anniversary_local_data_source.dart';
import '../models/anniversary_model.dart';

class AnniversaryRepositoryImpl implements AnniversaryRepository {
  final AnniversaryLocalDataSource localDataSource;
  AnniversaryRepositoryImpl(this.localDataSource);

  @override
  Future<List<Anniversary>> getAllAnniversaries() async {
    final models = await localDataSource.getAllAnniversaries();
    // Chuyển danh sách model sang danh sách entity
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addAnniversary(Anniversary anniversary) async {
    final model = AnniversaryModel.fromEntity(anniversary);
    await localDataSource.addAnniversary(model);
  }

  @override
  Future<void> updateAnniversary(Anniversary anniversary) async {
    final model = AnniversaryModel.fromEntity(anniversary);
    await localDataSource.updateAnniversary(model);
  }

  @override
  Future<void> deleteAnniversary(int id) async {
    await localDataSource.deleteAnniversary(id);
  }
}
