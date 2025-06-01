import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class GetAllJournals {
  final JournalRepository repository;
  GetAllJournals(this.repository);

  Future<List<Journal>> call() async {
    return await repository.getAllJournals();
  }
}
