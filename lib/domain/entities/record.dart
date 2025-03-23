class Record {
  final String id;
  final String imagePath;
  final String title;
  final String description;
  final DateTime date;

  Record({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  String toString() {
    return 'Record{id: $id, title: $title, description: $description, date: $date}';
  }
}
