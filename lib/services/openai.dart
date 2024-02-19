import 'dart:io';

import 'package:openai_dart/openai_dart.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/models/collections/chat.dart';
import 'package:qchat/models/collections/message.dart';

/// OpenAI
class OpenAIBot {
  static Future<void> get(
    List<Message> messages,
    Chat chat,
    Function(String) onInsert,
    Function(String) onAdd,
    Function(String) onFinish,
  ) async {
    String apiKey = PrefsHelper.openAIKey.trim();
    if (apiKey.isEmpty) {
      apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';
    }
    String baseUrl = PrefsHelper.openAIBaseUrl;
    if (baseUrl == 'https://api.openai.com/v1') {
      baseUrl = Platform.environment['OPENAI_BASE_URL'] ??
          'https://api.openai.com/v1';
    }
    final client = OpenAIClient(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    List<ChatCompletionMessage> msgs = [];
    for (Message e in messages) {
      msgs.add(e.role == 'user'
          ? ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(e.content),
            )
          : ChatCompletionMessage.assistant(content: e.content));
    }
    logger.i('[Service]: OpenAI\n[Model]: ${chat.model}\n'
        '[API Key]: $apiKey\n[Base Url]: $baseUrl\n'
        '[Temperature]: ${chat.temperature}\n[Query]: ${messages.last.content}');
    final chatStream = client.createChatCompletionStream(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(chat.model),
        messages: msgs,
        temperature: chat.temperature,
      ),
    );
    String result = '';
    onInsert(result);
    await for (final streamChatCompletion in chatStream) {
      final String? content = streamChatCompletion.choices.first.delta.content;
      if (content != null) {
        result += content;
        onAdd(result);
      }
    }
    onFinish(result);
  }
}
