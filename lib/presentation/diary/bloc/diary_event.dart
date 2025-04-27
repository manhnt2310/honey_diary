import 'package:equatable/equatable.dart';
import '../../../domain/entities/anniversary.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();
  @override
  List<Object?> get props => [];
}

class LoadAnniversariesEvent extends DiaryEvent {}

class AddAnniversaryEvent extends DiaryEvent {
  final Anniversary anniversary;
  const AddAnniversaryEvent(this.anniversary);

  @override
  List<Object?> get props => [anniversary];
}

class UpdateAnniversaryEvent extends DiaryEvent {
  final Anniversary anniversary;
  const UpdateAnniversaryEvent(this.anniversary);

  @override
  List<Object?> get props => [anniversary];
}

class DeleteAnniversaryEvent extends DiaryEvent {
  final int id;
  const DeleteAnniversaryEvent(this.id);

  @override
  List<Object?> get props => [id];
}
