// // test/domain/usecases/journal_usecases_test.dart

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:honey_diary/domain/entities/journal.dart';
// import 'package:honey_diary/domain/repositories/journal_repository.dart';
// import 'package:honey_diary/domain/usecases/add_journal.dart';
// import 'package:honey_diary/domain/usecases/delete_journal.dart';
// import 'package:honey_diary/domain/usecases/get_all_journals.dart';
// import 'package:honey_diary/domain/usecases/update_journal.dart';

// // Mock JournalRepository dùng Mockito 5.x:
// class MockJournalRepository extends Mock implements JournalRepository {}

// void main() {
//   late MockJournalRepository mockRepository;
//   late AddJournal addJournalUsecase;
//   late DeleteJournal deleteJournalUsecase;
//   late GetAllJournals getAllJournalsUsecase;
//   late UpdateJournal updateJournalUsecase;

//   // Một đối tượng Journal mẫu để sử dụng trong các test:
//   final tJournal = Journal(
//     id: 1,
//     title: 'Test Journal',
//     date: DateTime(2025, 6, 3),
//     description: 'Mô tả test',
//     imagePaths: ['img1.png'],
//   );

//   setUp(() {
//     mockRepository = MockJournalRepository();
//     addJournalUsecase = AddJournal(mockRepository);
//     deleteJournalUsecase = DeleteJournal(mockRepository);
//     getAllJournalsUsecase = GetAllJournals(mockRepository);
//     updateJournalUsecase = UpdateJournal(mockRepository);
//   });

//   group('AddJournal Usecase', () {
//     test('should call repository.addJournal with correct Journal', () async {
//       // Arrange:
//       //  • Dùng argThat(isA<Journal>()) để match bất kỳ Journal nào
//       //  • Dùng thenAnswer((_) => Future<void>.value()) để trả về Future<void> đúng kiểu
//       when(() => mockRepository.addJournal(any<Journal>()))
//         .thenAnswer((_) async {});

//       // Act
//       await addJournalUsecase.call(tJournal);

//       // Assert: verify đã gọi đúng với tJournal
//       verify(mockRepository.addJournal(tJournal)).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });

//     test('should propagate exception when repository.addJournal throws', () async {
//       // Arrange: mock repository.addJournal ném exception
//       when(mockRepository.addJournal(any<Journal>()))
//         .thenThrow(Exception('Add failed'));

//       // Act & Assert: usecase cũng ném ra exception
//       expect(
//         () => addJournalUsecase.call(tJournal),
//         throwsA(isA<Exception>()),
//       );
//       verify(() => mockRepository.addJournal(tJournal)).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });
//   });

//   group('DeleteJournal Usecase', () {
//     const tId = 123;

//     test('should call repository.deleteJournal with correct id', () async {
//       // Arrange: dùng argThat(isA<int>()) và trả về Future<void>
//       when(() => mockRepository.deleteJournal(any<int>()))
//         .thenAnswer((_) => Future.value());

//       // Act
//       await deleteJournalUsecase.call(tId);

//       // Assert
//       verify(() => mockRepository.deleteJournal(tId)).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });

//     test('should propagate exception when repository.deleteJournal throws', () async {
//       when(() => mockRepository.deleteJournal(any<int>()))
//         .thenThrow(Exception('Delete failed'));

//       expect(
//         () => deleteJournalUsecase.call(tId),
//         throwsA(isA<Exception>()),
//       );
//       verify(() => mockRepository.deleteJournal(tId)).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });
//   });

//   group('GetAllJournals Usecase', () {
//     final tJournalList = [
//       tJournal,
//       Journal(id: 2, title: 'Journal 2', date: DateTime(2025, 6, 4)),
//     ];

//     test('should return list of Journal when repository.getAllJournals succeeds', () async {
//       // Arrange: getAllJournals trả Future<List<Journal>>
//       when(() => mockRepository.getAllJournals())
//         .thenAnswer((_) async => tJournalList);

//       // Act
//       final result = await getAllJournalsUsecase.call();

//       // Assert
//       expect(result, tJournalList);
//       verify(() => mockRepository.getAllJournals()).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });

//     test('should propagate exception when repository.getAllJournals throws', () async {
//       when(() => mockRepository.getAllJournals())
//         .thenThrow(Exception('Fetch failed'));

//       expect(
//         () => getAllJournalsUsecase.call(),
//         throwsA(isA<Exception>()),
//       );
//       verify(() => mockRepository.getAllJournals()).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });
//   });

//   group('UpdateJournal Usecase', () {
//     test('should call repository.updateJournal with correct Journal', () async {
//       // Arrange: trả về Future<void>
//       when(() => mockRepository.updateJournal(any<Journal>()))
//         .thenAnswer((_) => Future<void>.value());

//       // Act
//       await updateJournalUsecase.call(tJournal);

//       // Assert
//       verify(() => mockRepository.updateJournal(tJournal)).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });

//     test('should propagate exception when repository.updateJournal throws', () async {
//       when(() => mockRepository.updateJournal(any<Journal>()))
//         .thenThrow(Exception('Update failed'));

//       expect(
//         () => updateJournalUsecase.call(tJournal),
//         throwsA(isA<Exception>()),
//       );
//       verify(() => mockRepository.updateJournal(tJournal)).called(1);
//       verifyNoMoreInteractions(mockRepository);
//     });
//   });
// }
