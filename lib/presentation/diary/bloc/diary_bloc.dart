import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_journal.dart';
import '../../../domain/usecases/delete_journal.dart';
import '../../../domain/usecases/get_all_journals.dart';
import '../../../domain/usecases/update_journal.dart';
import 'diary_event.dart';
import 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final GetAllJournals getAllJournals;
  final AddJournal addJournal;
  final UpdateJournal updateJournal;
  final DeleteJournal deleteJournal;

  DiaryBloc({
    required this.getAllJournals,
    required this.addJournal,
    required this.updateJournal,
    required this.deleteJournal,
  }) : super(DiaryInitial()) {
    on<LoadJournalsEvent>(_onLoad);
    on<AddJournalEvent>(_onAdd);
    on<UpdateJournalEvent>(_onUpdate);
    on<DeleteJournalEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadJournalsEvent event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      final list = await getAllJournals();
      // sort mới → cũ
      list.sort((a, b) => b.date.compareTo(a.date));
      emit(DiaryLoaded(list));
    } catch (e) {
      emit(DiaryError('Load failed: $e'));
    }
  }

  Future<void> _onAdd(AddJournalEvent event, Emitter<DiaryState> emit) async {
    try {
      await addJournal(event.journal);
      emit(JournalOperationSuccess());
      add(LoadJournalsEvent());
    } catch (e) {
      emit(DiaryError('Add failed: $e'));
    }
  }

  Future<void> _onUpdate(
    UpdateJournalEvent event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      await updateJournal(event.journal);
      emit(JournalOperationSuccess());
      add(LoadJournalsEvent());
    } catch (e) {
      emit(DiaryError('Update failed: $e'));
    }
  }

  Future<void> _onDelete(
    DeleteJournalEvent event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      await deleteJournal(event.id);
      emit(JournalOperationSuccess());
      add(LoadJournalsEvent());
    } catch (e) {
      emit(DiaryError('Delete failed: $e'));
    }
  }
}
