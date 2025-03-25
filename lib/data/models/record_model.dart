class RecordModel {
  final String id;
  final String imagePath;
  final String title;
  final String description;
  final DateTime date;

  RecordModel({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.date,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'],
      imagePath: json['imagePath'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
