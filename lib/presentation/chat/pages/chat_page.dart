import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: '',
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(
    id: '1',
    firstName: 'Honey',
    lastName: 'Diary',
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Chat',
    lastName: 'GPT',
  );

  final List<ChatMessage> _messages = <ChatMessage>[];

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
        backgroundColor: Colors.tealAccent.shade400,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        messageOptions: MessageOptions(
          currentUserContainerColor: const Color.fromARGB(255, 76, 201, 255),
          containerColor: Colors.tealAccent.shade400,
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });

    List<Messages> messagesHistory =
        _messages.reversed.map((m) {
          if (m.user == _currentUser) {
            return Messages(role: Role.user, content: m.text);
          } else {
            return Messages(role: Role.assistant, content: m.text);
          }
        }).toList();
    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: messagesHistory.map((msg) => msg.toJson()).toList(),
      maxToken: 200,
    );

    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              text: element.message!.content,
              user: _gptChatUser,
              createdAt: DateTime.now(),
            ),
          );
        });
      }
    }
  }
}
