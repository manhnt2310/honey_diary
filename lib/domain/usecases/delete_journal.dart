import '../repositories/journal_repository.dart';

class DeleteJournal {
  final JournalRepository repository;
  DeleteJournal(this.repository);

  Future<void> call(int id) async {
    await repository.deleteJournal(id);
  }
}
