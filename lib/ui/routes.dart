import 'package:get/get.dart';
import 'package:qchat/ui/views/chat/chat_view.dart';
import 'package:qchat/ui/views/chat/chat_setting/chat_setting_view.dart';
import 'package:qchat/ui/views/search/search_view.dart';
import 'package:qchat/ui/views/setting/api_setting/api_setting_view.dart';
import 'package:qchat/ui/views/setting/api_setting/openai_setting_view.dart';
import 'package:qchat/ui/views/setting/api_setting/zhipuai_setting_view.dart';
import 'package:qchat/ui/views/setting/parameter_setting/parameter_setting_view.dart';
import 'package:qchat/ui/views/setting/setting_view.dart';
import 'package:qchat/ui/views/setting/theme_setting/theme_setting_view.dart';

class AppRputes {
  static final List<GetPage> routes = [
    // 对话主页
    GetPage(name: '/chat', page: () => const ChatView()),
    // 对话设置
    GetPage(name: '/chat/setting', page: () => const ChatSettingView()),
    // 搜索对话
    GetPage(name: '/search', page: () => const SearchView()),
    // 设置
    GetPage(name: '/setting', page: () => const SettingView()),
    // 主题设置
    GetPage(name: '/setting/theme', page: () => ThemeSettingView()),
    // API 设置
    GetPage(name: '/setting/api', page: () => const APISettingView()),
    // OpenAI API 设置
    GetPage(name: '/setting/api/openai', page: () => const OpenAISettingView()),
    // 智谱 AI API 设置
    GetPage(
        name: '/setting/api/zhipuai', page: () => const ZhipuAISettingView()),
    // 参数设置
    GetPage(
        name: '/setting/parameter', page: () => const ParameterSettingView()),
  ];
}
