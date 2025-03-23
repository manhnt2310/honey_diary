import '../repositories/record_repository.dart';

class DeleteRecordUsecase {
  final RecordRepository _recordRepository;

  DeleteRecordUsecase(this._recordRepository);

  Future<void> execute(Record record) async {
    await _recordRepository.delete(record);
  }
}
