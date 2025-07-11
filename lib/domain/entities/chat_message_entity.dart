class ChatMessageEntity {
  final String id;
  final String text;
  final String userId;
  final DateTime createdAt;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
  });
}
