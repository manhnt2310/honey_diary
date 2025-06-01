// data/repositories/journal_repository_impl.dart
import '../../domain/entities/journal.dart';
import '../../domain/repositories/journal_repository.dart';
import '../data_sources/journal_local_data_source.dart';
import '../models/journal_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;
  JournalRepositoryImpl(this.localDataSource);

  @override
  Future<List<Journal>> getAllJournals() async {
    final models = await localDataSource.getAllJournals();
    // Chuyển danh sách model sang danh sách entity
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addJournal(Journal journal) async {
    final model = JournalModel.fromEntity(journal);
    await localDataSource.addJournal(model);
  }

  @override
  Future<void> updateJournal(Journal journal) async {
    final model = JournalModel.fromEntity(journal);
    await localDataSource.updateJournal(model);
  }

  @override
  Future<void> deleteJournal(int id) async {
    await localDataSource.deleteJournal(id);
  }
}
