import 'package:equatable/equatable.dart';
import '../../../domain/entities/journal.dart';

abstract class DiaryState extends Equatable {
  const DiaryState();
  @override
  List<Object?> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class DiaryLoaded extends DiaryState {
  final List<Journal> journals;
  const DiaryLoaded(this.journals);

  @override
  List<Object?> get props => [journals];
}

/// Dùng chung cho Add/Update/Delete thành công
class JournalOperationSuccess extends DiaryState {}

class DiaryError extends DiaryState {
  final String message;
  const DiaryError(this.message);

  @override
  List<Object?> get props => [message];
}
