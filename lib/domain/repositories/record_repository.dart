abstract class RecordRepository {
  Future<void> update(Record record);

  Future<void> delete(Record record);

  Future<void> add(Record record);
}
