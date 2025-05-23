import '../entities/anniversary.dart';
import '../repositories/anniversary_repository.dart';

class UpdateAnniversary {
  final AnniversaryRepository repository;
  UpdateAnniversary(this.repository);

  Future<void> call(Anniversary anniversary) async {
    await repository.updateAnniversary(anniversary);
  }
}
