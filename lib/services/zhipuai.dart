import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/models/collections/message.dart';
import 'package:qchat/services/utils/init_dio.dart';

/// 智谱 AI
class Zhipuai {
  /// https://open.bigmodel.cn/dev/api#http
  static Future<void> get(
    List<Message> messages,
    double temperature,
    Function(String) onInsert,
    Function(String) onAdd,
    Function(String) onFinish,
  ) async {
    final String apiKey = (prefs.getString('zhipuAIKey') ?? '').trim();
    final List<Map<String, String>> prompts = [];
    for (Message e in messages) {
      prompts.add({
        'role': e.role == 'user' ? 'user' : 'assistant',
        'content': e.content,
      });
    }
    const String url =
        'https://open.bigmodel.cn/api/paas/v4/chat/completions';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': _getJwt(apiKey),
    };
    final Map<String, dynamic> data = {
      'model': 'glm-4',
      'messages': prompts,
      'stream': 'True',
      'temperature': temperature,
    };
    final Dio dio = initDio();
    final Response response = await dio.post(
      url,
      data: data,
      options: Options(
        headers: headers,
        responseType: ResponseType.stream,
      ),
    );
    String result = '';
    bool first = true;
    await for (final item in response.data.stream) {
      String lines = utf8.decode(item).toString();
      logger.i(lines);
      ZhipuSSEModel sse = ZhipuSSEModel.fromData(lines);
      if (sse.event == 'add') {
        if (sse.data.isNotEmpty) {
          result += sse.data;
          if (first) {
            first = false;
            result = result.trimLeft();
            onInsert(result);
          } else {
            onAdd(result);
          }
        }
      } else {
        onFinish(result);
      }
    }
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

/// 智谱 AI SSE 解析
class ZhipuSSEModel {
  String? event = '';
  String? id = '';
  String data = '';
  ZhipuSSEModel({required this.data, required this.id, required this.event});
  ZhipuSSEModel.fromData(String data) {
    List lines = data.split('\n');
    lines = lines.sublist(0, lines.length - 2);
    for (String line in lines) {
      if (line.startsWith('event:')) {
        event = line.split('event:')[1];
      } else if (line.startsWith('id:')) {
        id = line.split('id:')[1];
      } else if (line.startsWith('data:')) {
        if (line.substring(5).isEmpty) {
          this.data = '${this.data}\n';
        } else {
          this.data = '${this.data}${line.substring(5)}';
        }
      } else {
        this.data = '${this.data}\n$line';
      }
    }
  }
}
