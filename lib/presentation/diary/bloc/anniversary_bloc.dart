import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_anniversary.dart';
import '../../../domain/usecases/delete_anniversary.dart';
import '../../../domain/usecases/get_all_anniversaries.dart';
import '../../../domain/usecases/update_anniversary.dart';
import 'anniversary_event.dart';
import 'anniversary_state.dart';

class AnniversaryBloc extends Bloc<AnniversaryEvent, AnniversaryState> {
  final GetAllAnniversaries getAllAnniversaries;
  final AddAnniversary addAnniversary;
  final UpdateAnniversary updateAnniversary;
  final DeleteAnniversary deleteAnniversary;

  AnniversaryBloc({
    required this.getAllAnniversaries,
    required this.addAnniversary,
    required this.updateAnniversary,
    required this.deleteAnniversary,
  }) : super(AnniversaryInitial()) {
    on<LoadAnniversariesEvent>((event, emit) async {
      emit(AnniversaryLoading());
      try {
        final list = await getAllAnniversaries.call();
        emit(AnniversaryLoaded(list));
      } catch (e) {
        emit(AnniversaryError('Failed to load data: $e'));
      }
    });

    on<AddAnniversaryEvent>((event, emit) async {
      try {
        await addAnniversary.call(event.anniversary);
        emit(AnniversaryOperationSuccess());
        // Tự động load lại danh sách sau khi thêm
        add(LoadAnniversariesEvent());
      } catch (e) {
        emit(AnniversaryError('Failed to add: $e'));
      }
    });

    on<UpdateAnniversaryEvent>((event, emit) async {
      try {
        await updateAnniversary.call(event.anniversary);
        emit(AnniversaryOperationSuccess());
        add(LoadAnniversariesEvent());
      } catch (e) {
        emit(AnniversaryError('Failed to update: $e'));
      }
    });

    on<DeleteAnniversaryEvent>((event, emit) async {
      try {
        await deleteAnniversary.call(event.id);
        emit(AnniversaryOperationSuccess());
        add(LoadAnniversariesEvent());
      } catch (e) {
        emit(AnniversaryError('Failed to delete: $e'));
      }
    });
  }
}
