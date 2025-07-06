import 'package:bloc/bloc.dart';

import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/usecases/send_massage.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc(this.sendMessageUseCase) : super(ChatState()) {
    on<SendMessageEvent>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
          messages: List.from(state.messages) // Copy current messages
          ..add(
            ChatMessageEntity(
              id: '0', // Temporary ID, should be replaced by backend
              text: event.text,
              userId: '0', // Temporary user ID, should be replaced by backend
              createdAt: DateTime.now(),
            ),
          ),
        ),
      );

      try {
        final ChatMessageEntity msg = await sendMessageUseCase(event.text);
        emit(
          state.copyWith(
            isLoading: false,
            messages: List.from(state.messages)
              //..removeWhere((m) => m.id == '0') // Remove temporary message
              ..add(msg), // Add the actual message from backend
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
