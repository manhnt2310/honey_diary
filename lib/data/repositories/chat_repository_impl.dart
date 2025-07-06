import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_massage_repository.dart';
import '../data_sources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatMessageEntity>> fetchMessages() async {
    // could implement local cache; for now return empty
    return [];
  }

  @override
  Future<ChatMessageEntity> sendMessage(String text) {
    return remoteDataSource.send(text);
  }
}
