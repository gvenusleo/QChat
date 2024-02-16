import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/common/font_helper.dart';
import 'package:qchat/common/global.dart';
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
    logger.i('切换到主题模式：${[
      ThemeMode.system,
      ThemeMode.light,
      ThemeMode.dark
    ][value]}');
  }

  // 设置动态颜色
  void updateDynamicColor(bool value) {
    useDynamicColor.value = value;
    PrefsHelper.setUseDynamicColor(value);
    Get.forceAppUpdate();
    logger.i('切换动态颜色：$value');
  }

  // 设置主题字体
  void updateThemeFont(String value) {
    themeFont.value = value;
    PrefsHelper.setThemeFont(value);
    Get.forceAppUpdate();
    logger.i('切换主题字体：$value');
  }

  // 读取所有字体
  Future<void> readAllFont() async {
    fonts.value = await FontHelper.readAllFont();
    logger.i('读取所有字体：$fonts');
  }

  // 导入字体
  Future<void> loadLocalFont() async {
    bool statue = await FontHelper.loadLocalFont();
    if (statue) {
      readAllFont();
    }
  }

  // 删除指定字体
  Future<void> deleteFont(String font) async {
    await FontHelper.deleteFont(font);
    logger.i('删除字体：$font');
    if (themeFont.value == font) {
      updateThemeFont('默认字体');
    }
    readAllFont();
  }
}
