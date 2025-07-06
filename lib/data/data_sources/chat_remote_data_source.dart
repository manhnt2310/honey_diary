import 'package:flutter_gemini/flutter_gemini.dart';

import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatMessageModel> send(String text);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Gemini gemini = Gemini.instance;

  @override
  Future<ChatMessageModel> send(String text) async {
    final response = await gemini.prompt(parts: [Part.text(text)]);
    final output = response?.output ?? '';
    return ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: output,
      userId: 'honey',
      createdAt: DateTime.now(),
    );
  }
}
