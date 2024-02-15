import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/common/font_helper.dart';
import 'package:qchat/common/prefs_helper.dart';

class ThemeSettingController extends GetxController {
  // 主题模式
  RxInt themeMode = (PrefsHelper.themeMode).obs;
  // 是否使用动态颜色
  RxBool useDynamicColor = (PrefsHelper.useDynamicColor).obs;
  // 主题字体
  RxString themeFont = (PrefsHelper.themeFont).obs;

  // 字体列表
  RxList fonts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    readAllFont();
  }

  // 设置主题模式
  void updateThemeMode(int value) {
    themeMode.value = value;
    PrefsHelper.setThemeMode(value);
    Get.changeThemeMode(
      [ThemeMode.system, ThemeMode.light, ThemeMode.dark][value],
    );
  }

  // 设置动态颜色
  void updateDynamicColor(bool value) {
    useDynamicColor.value = value;
    PrefsHelper.setUseDynamicColor(value);
    Get.forceAppUpdate();
  }

  // 设置主题字体
  void updateThemeFont(String value) {
    themeFont.value = value;
    PrefsHelper.setThemeFont(value);
    Get.forceAppUpdate();
  }

  // 读取所有字体
  Future<void> readAllFont() async {
    fonts.value = await FontHelper.readAllFont();
  }

  // 导入字体
  Future<void> loadLocalFont() async {
    bool statue = await FontHelper.loadLocalFont();
    if (statue) {
      readAllFont();
    }
  }
}
