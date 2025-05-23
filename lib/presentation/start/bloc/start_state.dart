import 'package:equatable/equatable.dart';

abstract class StartState extends Equatable {
  const StartState();
  @override
  List<Object?> get props => [];
}

class StartInitial extends StartState {
  final DateTime? selectedDate;
  const StartInitial({this.selectedDate});

  @override
  List<Object?> get props => [selectedDate];
}

class StartLoading extends StartState {}

class StartSuccess extends StartState {
  final DateTime startDate;
  const StartSuccess(this.startDate);

  @override
  List<Object?> get props => [startDate];
}

class StartFailure extends StartState {
  final String error;
  const StartFailure(this.error);

  @override
  List<Object?> get props => [error];
}
