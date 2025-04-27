// class RecordModel {
//   final String id;
//   final String imagePath;
//   final String title;
//   final String description;
//   final DateTime date;

//   RecordModel({
//     required this.id,
//     required this.imagePath,
//     required this.title,
//     required this.description,
//     required this.date,
//   });

//   factory RecordModel.fromJson(Map<String, dynamic> json) {
//     return RecordModel(
//       id: json['id'],
//       imagePath: json['imagePath'],
//       title: json['title'],
//       description: json['description'],
//       date: DateTime.parse(json['date']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'imagePath': imagePath,
//       'title': title,
//       'description': description,
//       'date': date.toIso8601String(),
//     };
//   }
// }

// data/models/anniversary_model.dart
import '../../domain/entities/anniversary.dart';

class AnniversaryModel {
  final int id;
  final String title;
  final String dateString; // Lưu ngày dưới dạng String (ví dụ ISO8601)
  final String? description;
  final List<String>? imagePaths;

  AnniversaryModel({
    required this.id,
    required this.title,
    required this.dateString,
    this.description,
    this.imagePaths,
  });

  // Chuyển từ entity sang model để lưu
  factory AnniversaryModel.fromEntity(Anniversary ann) {
    return AnniversaryModel(
      id: ann.id,
      title: ann.title,
      dateString: ann.date.toIso8601String(),
      description: ann.description,
      imagePaths: ann.imagePaths,
    );
  }

  // Chuyển từ model sang entity sau khi đọc từ DB
  Anniversary toEntity() {
    return Anniversary(
      id: id,
      title: title,
      date: DateTime.parse(dateString),
      description: description,
      imagePaths: imagePaths,
    );
  }

  // Chuyển từ Map (DB) sang model
  factory AnniversaryModel.fromMap(Map<String, dynamic> map) {
    return AnniversaryModel(
      id: map['id'] as int,
      title: map['title'] as String,
      dateString: map['date'] as String,
      description: map['description'] as String?,
      imagePaths: (map['imagePaths'] as String?)?.split(','),
    );
  }

  // Chuyển từ model sang Map để lưu vào DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': dateString,
      'description': description,
      'imagePaths': imagePaths?.join(','),
    };
  }
}
