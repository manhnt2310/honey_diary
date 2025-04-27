import '../../../domain/entities/anniversary.dart';

abstract class AnniversaryState {}

class AnniversaryInitial extends AnniversaryState {}

class AnniversaryLoading extends AnniversaryState {}

class AnniversaryLoaded extends AnniversaryState {
  final List<Anniversary> anniversaries;
  AnniversaryLoaded(this.anniversaries);
}

class AnniversaryOperationSuccess extends AnniversaryState {}

class AnniversaryError extends AnniversaryState {
  final String message;
  AnniversaryError(this.message);
}
