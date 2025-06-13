import 'package:flutter_bloc/flutter_bloc.dart';
import 'journal_addition_event.dart';
import 'journal_addition_state.dart';
import '../../../domain/entities/journal.dart';

class JournalAdditionBloc
    extends Bloc<JournalAdditionEvent, JournalAdditionState> {
  JournalAdditionBloc() : super(JournalAdditionState()) {
    on<InitializeJournalAddition>((event, emit) {
      if (event.journal != null) {
        emit(
          state.copyWith(
            title: event.journal!.title,
            description: event.journal!.description ?? '',
            date: event.journal!.date,
            imagePaths: List.from(event.journal!.imagePaths as Iterable),
            journal: event.journal,
          ),
        );
      }
    });

    on<TitleChanged>((event, emit) {
      emit(state.copyWith(title: event.title, showError: false));
    });
    on<DescriptionChanged>((event, emit) {
      emit(state.copyWith(description: event.description));
    });
    on<DateChanged>((event, emit) {
      emit(state.copyWith(date: event.date));
    });
    on<ImagesChanged>((event, emit) {
      emit(
        state.copyWith(
          imagePaths: List.from(state.imagePaths)..addAll(event.imagePaths),
        ),
      );
    });
    on<SaveJournal>((event, emit) {
      if (state.title.trim().isEmpty) {
        emit(state.copyWith(showError: true));
      } else {
        final j =
            state.journal != null
                ? Journal(
                  id: state.journal!.id,
                  title: state.title.trim(),
                  date: state.date,
                  imagePaths: state.imagePaths,
                  description: state.description.trim(),
                )
                : Journal(
                  id: state.journal!.id,
                  title: state.title.trim(),
                  date: state.date,
                  imagePaths: state.imagePaths,
                  description: state.description.trim(),
                );
        add(JournalSaved(j));
      }
    });

    on<JournalSaved>((event, emit) => null);
  }
}
