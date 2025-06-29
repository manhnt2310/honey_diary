import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> fetchMessages();
  Future<ChatMessageEntity> sendMessage(String text);
}
