import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/ui/widgets/list_item.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('设置'),
            ),
            SliverList.list(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListItem(
                    icon: const Icon(Icons.color_lens_outlined),
                    title: '外观设置',
                    onTap: () {
                      Get.toNamed('/setting/theme');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListItem(
                        icon: const Icon(Icons.webhook_outlined),
                        title: 'API 设置',
                        onTap: () {
                          Get.toNamed('/setting/api');
                        },
                        bottomRadius: false,
                      ),
                      const Divider(),
                      ListItem(
                        icon: const Icon(Icons.dashboard_customize_outlined),
                        title: '默认参数',
                        onTap: () {
                          Get.toNamed('/setting/parameter');
                        },
                        topRadius: false,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListItem(
                    icon: const Icon(Icons.policy_outlined),
                    title: '开源协议',
                    onTap: () {
                      Get.toNamed('/setting/license');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
