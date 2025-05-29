import '../entities/anniversary.dart';

abstract class AnniversaryRepository {
  Future<List<Anniversary>> getAllAnniversaries();
  Future<void> addAnniversary(Anniversary anniversary);
  Future<void> updateAnniversary(Anniversary anniversary);
  Future<void> deleteAnniversary(int id);
}
