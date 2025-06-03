import 'package:flutter_test/flutter_test.dart';
import 'package:honey_diary/domain/entities/journal.dart';

void main() {
  group('Journal entity', () {
    test('should create a Journal with all required fields', () {
      // Arrange: chuan bi du lieu dau vao
      const int tId = 42;
      const String tTitle = 'My First Journal';
      final DateTime tDate = DateTime(2023, 10, 1);
      const String tDescription = 'This is a test journal.';
      final List<String> tImagePaths = [
        'path/to/image1.jpg',
        'path/to/image2.jpg',
      ];

      // Act: khoi tai doi tuong Journal
      final journal = Journal(
        id: tId,
        title: tTitle,
        date: tDate,
        description: tDescription,
        imagePaths: tImagePaths,
      );

      // Assert: kiem tra cac truong co duoc gan dung khong
      expect(journal.id, tId);
      expect(journal.title, tTitle);
      expect(journal.date, tDate);
      expect(journal.description, tDescription);
      expect(journal.imagePaths, tImagePaths);
    });

    test(
      'should default imagePaths to an empty list when passing imagePaths as null',
      () {
        // Arrange
        const int tId = 7;
        const String tTitle = 'My Journal';
        final DateTime tDate = DateTime(2023, 10, 3);

        // Act
        final journal = Journal(id: tId, title: tTitle, date: tDate);

        // Assert
        expect(journal.id, tId);
        expect(journal.title, tTitle);
        expect(journal.date, tDate);
        expect(journal.description, isNull);
        expect(journal.imagePaths, isA<List<String>>());
        expect(journal.imagePaths, isEmpty);
      },
    );

    test('should allow description to be null explicitly', () {
      // Arrange
      const int tId = 123;
      const String tTitle = 'tieu de';
      final DateTime tDate = DateTime(2023, 10, 5);

      //Act
      final journal = Journal(
        id: tId,
        title: tTitle,
        date: tDate,
        description: null, // Explicitly passing null
        imagePaths: ['a.png'],
      );

      // Assert
      expect(journal.id, tId);
      expect(journal.title, tTitle);
      expect(journal.date, tDate);
      expect(journal.description, isNull); // Description should be null
      expect(journal.imagePaths, [
        'a.png',
      ]); // Image paths should contain the provided path
    });
  });
}
