import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class UpdateJournal {
  final JournalRepository repository;
  UpdateJournal(this.repository);

  Future<void> call(Journal journal) async {
    await repository.updateJournal(journal);
  }
}
