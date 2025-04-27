class Anniversary {
  final int id;
  final String title;
  final DateTime date;
  final String? description;
  final List<String>? imagePaths;

  Anniversary({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    this.imagePaths,
  });
}
