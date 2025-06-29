import '../../../domain/entities/chat_message_entity.dart';

class ChatState {
  final bool isLoading;
  final List<ChatMessageEntity> messages;
  final String? errorMessage;

  ChatState({
    this.isLoading = false,
    this.messages = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    bool? isLoading,
    List<ChatMessageEntity>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
