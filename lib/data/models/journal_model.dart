import '../../domain/entities/journal.dart';

class JournalModel {
  final int id;
  final String title;
  final String dateString; // Lưu ngày dưới dạng String (ví dụ ISO8601)
  final String? content;
  final String?
  imagePathsString; // Lưu danh sách ảnh dưới dạng chuỗi (ví dụ: đường dẫn phân cách dấu phẩy) "path1, path2,..."

  JournalModel({
    required this.id,
    required this.title,
    required this.dateString,
    this.content,
    this.imagePathsString,
  });

  // Chuyển từ entity sang model để lưu
  factory JournalModel.fromEntity(Journal ann) {
    return JournalModel(
      id: ann.id,
      title: ann.title,
      dateString: ann.date.toIso8601String(),
      content: ann.description,
      imagePathsString: ann.imagePaths?.join(','),
    );
  }

  // Chuyển từ model sang entity sau khi đọc từ DB
  Journal toEntity() {
    return Journal(
      id: id,
      title: title,
      date: DateTime.parse(dateString),
      description: content,
      imagePaths:
          imagePathsString!.isEmpty
              ? []
              : imagePathsString?.split(',').map((s) => s.trim()).toList(),
    );
  }

  // Chuyển từ Map (DB) sang model
  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'] as int,
      title: map['title'] as String,
      dateString: map['date'] as String,
      content: map['content'] as String?,
      imagePathsString: map['imagePaths'] as String? ?? '',
    );
  }

  // Chuyển từ model sang Map để lưu vào DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': dateString,
      'content': content,
      'imagePaths': imagePathsString ?? '',
    };
  }
}
