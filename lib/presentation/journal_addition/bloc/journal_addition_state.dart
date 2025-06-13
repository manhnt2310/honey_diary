import '../../../domain/entities/journal.dart';

class JournalAdditionState {
  final String title;
  final String description;
  final DateTime date;
  final List<String> imagePaths;
  final Journal? journal;
  final bool showError;

  JournalAdditionState({
    this.title = '',
    this.description = '',
    DateTime? date,
    List<String>? imagePaths,
    this.journal,
    this.showError = false,
  }) : date = date ?? DateTime.now(),
       imagePaths = imagePaths ?? [];

  JournalAdditionState copyWith({
    String? title,
    String? description,
    DateTime? date,
    List<String>? imagePaths,
    Journal? journal,
    bool? showError,
  }) {
    return JournalAdditionState(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      imagePaths: imagePaths ?? this.imagePaths,
      journal: journal ?? this.journal,
      showError: showError ?? this.showError,
    );
  }
}
