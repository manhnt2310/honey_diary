import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'start_event.dart';
import 'start_state.dart';

class StartBloc extends Bloc<StartEvent, StartState> {
  StartBloc() : super(const StartInitial()) {
    on<DatePicked>(_onDatePicked);
    on<StartPressed>(_onStartPressed);
  }

  Future<void> _onDatePicked(DatePicked event, Emitter<StartState> emit) async {
    emit(StartInitial(selectedDate: event.date));
  }

  Future<void> _onStartPressed(
    StartPressed event,
    Emitter<StartState> emit,
  ) async {
    final currentState = state;
    if (currentState is StartInitial && currentState.selectedDate != null) {
      emit(StartLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'selectedDate',
          currentState.selectedDate!.toIso8601String(),
        );
        await prefs.setBool('hasSeenIntro', true);
        emit(StartSuccess(currentState.selectedDate!));
      } catch (e) {
        emit(StartFailure(e.toString()));
      }
    }
  }
}
