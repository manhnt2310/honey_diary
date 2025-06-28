import '../../../domain/entities/journal.dart';

abstract class JournalAdditionEvent {}

class InitializeJournalAddition extends JournalAdditionEvent {
  final Journal? journal;
  InitializeJournalAddition(this.journal);
}

class TitleChanged extends JournalAdditionEvent {
  final String title;
  TitleChanged(this.title);
}

class DescriptionChanged extends JournalAdditionEvent {
  final String description;
  DescriptionChanged(this.description);
}

class DateChanged extends JournalAdditionEvent {
  final DateTime date;
  DateChanged(this.date);
}

class ImagesChanged extends JournalAdditionEvent {
  final List<String> imagePaths;
  ImagesChanged(this.imagePaths);
}

class SaveJournal extends JournalAdditionEvent {}

class JournalSaved extends JournalAdditionEvent {
  final Journal journal;
  JournalSaved(this.journal);
}
