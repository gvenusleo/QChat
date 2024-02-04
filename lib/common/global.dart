import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appVersion = '0.0.1';
late Logger logger;
late SharedPreferences prefs;
late Isar isar;

const List<AIProvider> allAIProviders = [
  AIProvider(
    name: 'OpenAI',
    models: ['ChatGPT-3.5-turbo'],
    image: 'assets/ai/openai.png',
  ),
  AIProvider(
    name: '智谱 AI',
    models: ['ChatGLM-Turbo'],
    image: 'assets/ai/zhipuai.png',
  )
];

class AIProvider {
  final String name;
  final List<String> models;
  final String image;

  const AIProvider({
    required this.name,
    required this.models,
    required this.image,
  });
}
