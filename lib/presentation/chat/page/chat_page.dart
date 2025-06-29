import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import '../../../core/utils/injections.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Honey Chat')),
      body: BlocProvider.value(value: sl<ChatBloc>(), child: ChatView()),
    );
  }
}

class ChatView extends StatelessWidget {
  final ChatUser currentUser = ChatUser(id: '0', firstName: 'User');

  ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return DashChat(
          currentUser: currentUser,
          messages:
              state.messages
                  .map(
                    (e) => ChatMessage(
                      text: e.text,
                      user: ChatUser(id: e.userId, firstName: e.userId),
                      createdAt: e.createdAt,
                    ),
                  )
                  .toList(),
          onSend:
              (msg) => context.read<ChatBloc>().add(SendMessageEvent(msg.text)),
        );
      },
    );
  }
}
