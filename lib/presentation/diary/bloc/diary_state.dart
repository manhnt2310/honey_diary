import 'package:equatable/equatable.dart';
import '../../../domain/entities/anniversary.dart';

abstract class DiaryState extends Equatable {
  const DiaryState();
  @override
  List<Object?> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class DiaryLoaded extends DiaryState {
  final List<Anniversary> anniversaries;
  const DiaryLoaded(this.anniversaries);

  @override
  List<Object?> get props => [anniversaries];
}

/// Dùng chung cho Add/Update/Delete thành công
class AnniversaryOperationSuccess extends DiaryState {}

class DiaryError extends DiaryState {
  final String message;
  const DiaryError(this.message);

  @override
  List<Object?> get props => [message];
}
