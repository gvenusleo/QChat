import 'package:qchat/common/global.dart';

class PrefsHelper {
  // 主题模式
  static int themeMode = prefs.getInt('themeMode') ?? 0;

  static Future<void> setThemeMode(int value) async {
    themeMode = value;
    await prefs.setInt('themeMode', value);
  }

  // 是否使用动态颜色
  static bool useDynamicColor = prefs.getBool('useDynamicColor') ?? true;

  static Future<void> setUseDynamicColor(bool value) async {
    useDynamicColor = value;
    await prefs.setBool('useDynamicColor', value);
  }

  // 主题字体
  static String themeFont = prefs.getString('themeFont') ?? '默认字体';

  static Future<void> setThemeFont(String value) async {
    themeFont = value;
    await prefs.setString('themeFont', value);
  }

  // 默认采样温度
  static double defaultTemperature =
      prefs.getDouble('defaultTemperature') ?? 0.7;

  static Future<void> setDefaultTemperature(double value) async {
    defaultTemperature = value;
    await prefs.setDouble('defaultTemperature', value);
  }

  // 默认历史消息数
  static int defaultHistoryMessages =
      prefs.getInt('defaultHistoryMessages') ?? 3;

  static Future<void> setDefaultHistoryMessages(int value) async {
    defaultHistoryMessages = value;
    await prefs.setInt('defaultHistoryMessages', value);
  }
}
