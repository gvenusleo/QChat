import 'package:dart_openai/dart_openai.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/models/collections/message.dart';

/// OpenAI
class OpenAIBot {
  static Future<void> get(
    List<Message> messages,
    Function(String) onInsert,
    Function(String) onAdd,
    Function(String) onFinish,
  ) async {
    final String apiKey = (prefs.getString('openAIKey') ?? '').trim();
    final String server =
        prefs.getString('openAIServer') ?? 'https://api.openai.com';
    OpenAI.requestsTimeOut = const Duration(seconds: 1);
    OpenAI.baseUrl = server;
    OpenAI.apiKey = apiKey;
    List<OpenAIChatCompletionChoiceMessageModel> msgs = [];
    for (Message e in messages) {
      msgs.add(
        OpenAIChatCompletionChoiceMessageModel(
          role: e.role == 'user'
              ? OpenAIChatMessageRole.user
              : OpenAIChatMessageRole.assistant,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              e.content,
            ),
          ],
        ),
      );
    }
    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: msgs,
    );
    String result = '';
    bool isFirst = true;
    chatStream.listen(
      (streamChatCompletion) {
        final List<OpenAIChatCompletionChoiceMessageContentItemModel>? content =
            streamChatCompletion.choices.first.delta.content;
        if (content != null) {
          for (final item in content) {
            result += item.text ?? '';
            if (isFirst) {
              onInsert(result);
              isFirst = false;
            } else {
              onAdd(result);
            }
          }
        }
      },
      onDone: () {
        onFinish(result);
      },
    );
  }
}
