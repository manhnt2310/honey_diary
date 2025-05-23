import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_anniversary.dart';
import '../../../domain/usecases/delete_anniversary.dart';
import '../../../domain/usecases/get_all_anniversaries.dart';
import '../../../domain/usecases/update_anniversary.dart';
import 'diary_event.dart';
import 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final GetAllAnniversaries getAllAnniversaries;
  final AddAnniversary addAnniversary;
  final UpdateAnniversary updateAnniversary;
  final DeleteAnniversary deleteAnniversary;

  DiaryBloc({
    required this.getAllAnniversaries,
    required this.addAnniversary,
    required this.updateAnniversary,
    required this.deleteAnniversary,
  }) : super(DiaryInitial()) {
    on<LoadAnniversariesEvent>(_onLoad);
    on<AddAnniversaryEvent>(_onAdd);
    on<UpdateAnniversaryEvent>(_onUpdate);
    on<DeleteAnniversaryEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadAnniversariesEvent event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    try {
      final list = await getAllAnniversaries();
      // sort mới → cũ
      list.sort((a, b) => b.date.compareTo(a.date));
      emit(DiaryLoaded(list));
    } catch (e) {
      emit(DiaryError('Load failed: $e'));
    }
  }

  Future<void> _onAdd(
    AddAnniversaryEvent event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      await addAnniversary(event.anniversary);
      emit(AnniversaryOperationSuccess());
      add(LoadAnniversariesEvent());
    } catch (e) {
      emit(DiaryError('Add failed: $e'));
    }
  }

  Future<void> _onUpdate(
    UpdateAnniversaryEvent event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      await updateAnniversary(event.anniversary);
      emit(AnniversaryOperationSuccess());
      add(LoadAnniversariesEvent());
    } catch (e) {
      emit(DiaryError('Update failed: $e'));
    }
  }

  Future<void> _onDelete(
    DeleteAnniversaryEvent event,
    Emitter<DiaryState> emit,
  ) async {
    try {
      await deleteAnniversary(event.id);
      emit(AnniversaryOperationSuccess());
      add(LoadAnniversariesEvent());
    } catch (e) {
      emit(DiaryError('Delete failed: $e'));
    }
  }
}
