import 'package:qchat/common/global.dart';

class PrefsHelper {
  // 主题模式
  static int themeMode = prefs.getInt('themeMode') ?? 0;
  static Future<void> updateThemeMode(int value) async {
    themeMode = value;
    await prefs.setInt('themeMode', value);
  }

  // 是否使用动态颜色
  static bool useDynamicColor = prefs.getBool('useDynamicColor') ?? true;
  static Future<void> updateUseDynamicColor(bool value) async {
    useDynamicColor = value;
    await prefs.setBool('useDynamicColor', value);
  }

  // 主题字体
  static String themeFont = prefs.getString('themeFont') ?? '默认字体';
  static Future<void> updateThemeFont(String value) async {
    themeFont = value;
    await prefs.setString('themeFont', value);
  }

  // 默认采样温度
  static double defaultTemperature =
      prefs.getDouble('defaultTemperature') ?? 0.7;
  static Future<void> updateDefaultTemperature(double value) async {
    defaultTemperature = value;
    await prefs.setDouble('defaultTemperature', value);
  }

  // 默认历史消息数
  static int defaultHistoryMessages =
      prefs.getInt('defaultHistoryMessages') ?? 3;
  static Future<void> updateDefaultHistoryMessages(int value) async {
    defaultHistoryMessages = value;
    await prefs.setInt('defaultHistoryMessages', value);
  }

  // openAI Key
  static String openAIKey = prefs.getString('openAIKey') ?? '';
  static Future<void> updateOpenAIKey(String value) async {
    openAIKey = value;
    await prefs.setString('openAIKey', value);
  }

  // openAI Base Url
  static String openAIBaseUrl =
      prefs.getString('openAIBaseUrl') ?? 'https://api.openai.com/v1';
  static Future<void> updateOpenAIBaseUrl(String value) async {
    openAIBaseUrl = value;
    await prefs.setString('openAIBaseUrl', value);
  }

  // Moonshot AI Key
  static String moonshotAIKey = prefs.getString('moonshotAIKey') ?? '';
  static Future<void> updateMoonshotAIKey(String value) async {
    moonshotAIKey = value;
    await prefs.setString('moonshotAIKey', value);
  }

  // 智谱 AI Key
  static String zhipuAIKey = prefs.getString('zhipuAIKey') ?? '';
  static Future<void> updateZhipuAIKey(String value) async {
    zhipuAIKey = value;
    await prefs.setString('zhipuAIKey', value);
  }
}
