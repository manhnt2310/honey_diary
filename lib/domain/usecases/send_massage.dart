import '../entities/chat_message_entity.dart';
import '../repositories/chat_massage_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<ChatMessageEntity> call(String text) {
    return repository.sendMessage(text);
  }
}
