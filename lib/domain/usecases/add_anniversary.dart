import '../entities/anniversary.dart';
import '../repositories/anniversary_repository.dart';

class AddAnniversary {
  final AnniversaryRepository repository;
  AddAnniversary(this.repository);

  Future<void> call(Anniversary anniversary) async {
    await repository.addAnniversary(anniversary);
  }
}
