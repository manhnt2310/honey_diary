import '../entities/journal.dart';
import '../repositories/journal_repository.dart';

class AddJournal {
  final JournalRepository repository;
  AddJournal(this.repository);

  Future<void> call(Journal journal) async {
    await repository.addJournal(journal);
  }
}
