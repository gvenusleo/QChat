import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/models/collections/chat.dart';
import 'package:qchat/models/collections/message.dart';
import 'package:qchat/services/utils/init_dio.dart';

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
    const String url = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';
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
    final Dio dio = initDio();
    final response = await dio.post(
      url,
      data: data,
      options: Options(
        headers: headers,
        responseType: ResponseType.stream,
      ),
    );
    String result = '';
    onInsert(result);
    StreamTransformer<Uint8List, List<int>> unit8Transformer =
        StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(List<int>.from(data));
      },
    );
    await response.data?.stream
        .transform(unit8Transformer)
        .transform(const Utf8Decoder())
        .transform(const LineSplitter())
        .where((final i) =>
            i.startsWith('data: ') && !i.endsWith('[DONE]') && i != '')
        .listen((event) {
      final Map<String, dynamic> json = jsonDecode(event.substring(6));
      final String content = json['choices'][0]['delta']['content'];
      result += content;
      onAdd(result);
    });
    onFinish(result);
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
