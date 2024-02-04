import 'package:dio/dio.dart';

Future<String> linkAI(String msg) async {
  const String url = 'https://api.link-ai.chat/v1/chat/completions';
  const String token = 'Link_noDj2kntl3zfsdvVJfdQuDR4nnRI0K81PwguvR5YOu';
  final Map<String, String> headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  final Map<String, dynamic> data = {
    'app_code': 'MM4Kz8A6',
    'messages': [
      {
        'role': 'user',
        'content': msg,
      },
    ],
  };
  try {
    final Dio dio = Dio();
    final Response response = await dio.post(
      url,
      data: data,
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      return response.data['choices'][0]['message']['content'];
    }
    return '请求错误！';
  } catch (e) {
    return '请求错误！';
  }
}
