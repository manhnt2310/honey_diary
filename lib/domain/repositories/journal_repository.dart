import '../entities/journal.dart';

abstract class JournalRepository {
  Future<List<Journal>> getAllJournals();
  Future<void> addJournal(Journal journal);
  Future<void> updateJournal(Journal journal);
  Future<void> deleteJournal(int id);
}
