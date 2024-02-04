import 'package:qchat/common/global.dart';

class PrefsHelper {
  static double defaultTemperature =
      prefs.getDouble('defaultTemperature') ?? 0.7;

  static Future<void> setDefaultTemperature(double value) async {
    defaultTemperature = value;
    await prefs.setDouble('defaultTemperature', value);
  }

  static int defaultHistoryMessages =
      prefs.getInt('defaultHistoryMessages') ?? 3;

  static Future<void> setDefaultHistoryMessages(int value) async {
    defaultHistoryMessages = value;
    await prefs.setInt('defaultHistoryMessages', value);
  }
}
