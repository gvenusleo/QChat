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
    models: [
      'gpt-4',
      'gpt-4-0314',
      'gpt-4-0613',
      'gpt-4-32k',
      'gpt-4-32k-0314',
      'gpt-4-32k-0613',
      'gpt-4-turbo-preview',
      'gpt-4-1106-preview',
      'gpt-4-0125-preview',
      'gpt-4-vision-preview',
      'gpt-3.5-turbo',
      'gpt-3.5-turbo-16k',
      'gpt-3.5-turbo-0301',
      'gpt-3.5-turbo-0613',
      'gpt-3.5-turbo-1106',
      'gpt-3.5-turbo-16k-0613'
    ],
    image: 'assets/ai/openai.png',
  ),
  AIProvider(
    name: 'Moonshot AI',
    models: [
      'moonshot-v1-8k',
      'moonshot-v1-32k',
      'moonshot-v1-128k',
    ],
    image: 'assets/ai/moonshotai.png',
  ),
  AIProvider(
    name: '智谱 AI',
    models: [
      'glm-4',
      'glm-3-turbo',
    ],
    image: 'assets/ai/zhipuai.png',
  ),
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
