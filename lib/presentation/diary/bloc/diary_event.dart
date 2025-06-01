import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();
  @override
  List<Object?> get props => [];
}

class LoadJournalsEvent extends DiaryEvent {}

class AddJournalEvent extends DiaryEvent {
  final Journal journal;
  const AddJournalEvent(this.journal);

  @override
  List<Object?> get props => [journal];
}

class UpdateJournalEvent extends DiaryEvent {
  final Journal journal;
  const UpdateJournalEvent(this.journal);

  @override
  List<Object?> get props => [journal];
}

class DeleteJournalEvent extends DiaryEvent {
  final int id;
  const DeleteJournalEvent(this.id);

  @override
  List<Object?> get props => [id];
}
