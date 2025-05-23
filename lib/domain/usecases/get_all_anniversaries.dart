import '../entities/anniversary.dart';
import '../repositories/anniversary_repository.dart';

class GetAllAnniversaries {
  final AnniversaryRepository repository;
  GetAllAnniversaries(this.repository);

  Future<List<Anniversary>> call() async {
    return await repository.getAllAnniversaries();
  }
}
