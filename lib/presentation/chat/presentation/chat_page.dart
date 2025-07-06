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
      appBar: AppBar(
        title: const Text(
          'Honey Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent, // 👈 để gradient hiển thị
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 76, 201, 255),
                Color.fromARGB(255, 244, 143, 177), // hồng nhạt
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
        final messages =
            state.messages
                .map(
                  (e) => ChatMessage(
                    text: e.text,
                    user: ChatUser(id: e.userId, firstName: e.userId),
                    createdAt: e.createdAt,
                  ),
                )
                .toList();

        final reversedMessages = messages.reversed.toList();

        return DashChat(
          currentUser: currentUser,
          messages: reversedMessages,
          onSend:
              (msg) => context.read<ChatBloc>().add(SendMessageEvent(msg.text)),
          inputOptions: InputOptions(
            sendButtonBuilder:
                (onSend) => IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color.fromARGB(
                      255,
                      240,
                      98,
                      146,
                    ), // <-- màu mong muốn
                    size: 24,
                  ),
                  onPressed: onSend,
                  padding: const EdgeInsets.only(right: 5),
                ),
            inputDecoration: InputDecoration(
              hintText: 'Ask anything...',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white, // Nền input
            ),
          ),

          /// 🎨 Tùy chỉnh màu của từng bubble
          messageOptions: MessageOptions(
            messageDecorationBuilder: (message, previousMessage, nextMessage) {
              final isUser = message.user.id == currentUser.id;
              if (!isUser) {
                return BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                );
              }

              // Vị trí của message trong danh sách (dựa trên reversedMessages)
              final index = reversedMessages.indexOf(message);
              final total = reversedMessages.length;

              // Tính tỉ lệ vị trí (0.0 → 1.0)
              final positionRatio = total <= 1 ? 0.0 : (index / (total - 1));

              // 🎨 Tạo gradient động theo vị trí
              final color = Color.lerp(
                const Color.fromARGB(255, 76, 201, 255),
                const Color.fromARGB(255, 244, 143, 177), // xanh
                positionRatio,
              );

              return BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
