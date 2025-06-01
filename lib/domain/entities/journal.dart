class Journal {
  final int id;
  final String title;
  final DateTime date;
  final String? description;
  final List<String>? imagePaths;

  Journal({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    List<String>? imagePaths,
  }) : imagePaths = imagePaths ?? [];
}
