import '../repositories/anniversary_repository.dart';

class DeleteAnniversary {
  final AnniversaryRepository repository;
  DeleteAnniversary(this.repository);

  Future<void> call(int id) async {
    await repository.deleteAnniversary(id);
  }
}
