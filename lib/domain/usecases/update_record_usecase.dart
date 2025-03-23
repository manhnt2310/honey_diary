import '../repositories/record_repository.dart';

class UpdateRecordUsecase {
  final RecordRepository _recordRepository;

  UpdateRecordUsecase(this._recordRepository);

  Future<void> execute(Record record) async {
    await _recordRepository.update(record);
  }
}
