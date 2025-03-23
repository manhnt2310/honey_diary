class RecordMapper {
  static Map<String, dynamic> toMap({
    required String id,
    required String imagePath,
    required String title,
    required String description,
    required DateTime date,
  }) {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
