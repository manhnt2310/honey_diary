import '../../../domain/entities/anniversary.dart';

abstract class AnniversaryEvent {}

class LoadAnniversariesEvent extends AnniversaryEvent {}

class AddAnniversaryEvent extends AnniversaryEvent {
  final Anniversary anniversary;
  AddAnniversaryEvent(this.anniversary);
}

class UpdateAnniversaryEvent extends AnniversaryEvent {
  final Anniversary anniversary;
  UpdateAnniversaryEvent(this.anniversary);
}

class DeleteAnniversaryEvent extends AnniversaryEvent {
  final int id;
  DeleteAnniversaryEvent(this.id);
}
