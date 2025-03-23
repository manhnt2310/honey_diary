import '../repositories/record_repository.dart';

class AddRecordUsecase {
  final RecordRepository _recordRepository;

  AddRecordUsecase(this._recordRepository);

  Future<void> execute(Record record) async {
    await _recordRepository.add(record);
  }
}
