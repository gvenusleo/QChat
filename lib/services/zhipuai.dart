import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:qchat/common/global.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/models/collections/chat.dart';
import 'package:qchat/models/collections/message.dart';

/// 智谱 AI
class ZhipuaiBot {
  /// https://open.bigmodel.cn/dev/api#http
  static Future<void> get(
    List<Message> messages,
    Chat chat,
    Function(String) onInsert,
    Function(String) onAdd,
    Function(String) onFinish,
  ) async {
    String apiKey = PrefsHelper.zhipuAIKey.trim();
    if (apiKey.isEmpty) {
      apiKey = Platform.environment['ZHIPUAI_API_KEY'] ?? '';
    }
    final List<Map<String, String>> prompts = [];
    for (Message e in messages) {
      prompts.add({
        'role': e.role == 'user' ? 'user' : 'assistant',
        'content': e.content,
      });
    }
    const String baseUrl = 'https://open.bigmodel.cn/api/paas/v4';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': _getJwt(apiKey),
    };
    final Map<String, dynamic> data = {
      'model': 'glm-4',
      'messages': prompts,
      'stream': true,
      'temperature': chat.temperature.toStringAsFixed(2),
    };
    logger.i('[Service]: 智谱 AI\n[Model]: ${chat.model}\n'
        '[API Key]: $apiKey\n[Base Url]: $baseUrl\n'
        '[Temperature]: ${chat.temperature}\n[Query]: ${messages.last.content}');
    final client = http.Client();
    String result = '';
    onInsert(result);
    final response = await client.send(
      http.Request(
        'POST',
        Uri.parse('$baseUrl/chat/completions'),
      )
        ..headers.addAll(headers)
        ..body = jsonEncode(data),
    );
    response.stream.transform(const _ZhipuAIStreamTransformer()).listen(
      (final value) {
        final Map<String, dynamic> map = json.decode(value);
        String content = map['choices'][0]['delta']['content'];
        result += content;
        onAdd(result);
        logger.i(result);
      },
    );
    onFinish(result);
    logger.i(result);
  }

  /// JWT 组装
  static String _getJwt(String apiKey) {
    final String id = apiKey.split('.').first;
    final String secret = apiKey.split('.').last;
    const Map<String, String> headers = {
      'alg': 'HS256',
      'sign_type': 'SIGN',
    };
    final Map<String, dynamic> payload = {
      'api_key': id,
      'exp': DateTime.now().millisecondsSinceEpoch + 10000,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final encodedHeader = base64Encode(utf8.encode(jsonEncode(headers)));
    final encodedPayload = base64Encode(utf8.encode(jsonEncode(payload)));
    final hmacSha256 = Hmac(sha256, utf8.encode(secret));
    final signature = base64Encode(hmacSha256
        .convert(utf8.encode('$encodedHeader.$encodedPayload'))
        .bytes);
    return '$encodedHeader.$encodedPayload.$signature';
  }
}

class _ZhipuAIStreamTransformer
    extends StreamTransformerBase<List<int>, String> {
  const _ZhipuAIStreamTransformer();

  @override
  Stream<String> bind(final Stream<List<int>> stream) {
    return stream //
        .transform(utf8.decoder) //
        .transform(const LineSplitter()) //
        .where((final i) => i.startsWith('data: ') && !i.endsWith('[DONE]'))
        .map((final item) => item.substring(6));
  }
}
