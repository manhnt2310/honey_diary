import 'package:equatable/equatable.dart';

abstract class StartEvent extends Equatable {
  const StartEvent();
  @override
  List<Object?> get props => [];
}

class DatePicked extends StartEvent {
  final DateTime date;
  const DatePicked(this.date);

  @override
  List<Object?> get props => [date];
}

class StartPressed extends StartEvent {
  const StartPressed();
}
