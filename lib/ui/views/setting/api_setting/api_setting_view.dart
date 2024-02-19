import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/ui/widgets/list_item_card.dart';

class APISettingView extends StatelessWidget {
  const APISettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('API 设置'),
            ),
            SliverList.list(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      ListItemCard(
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.asset(
                            'assets/ai/openai.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        title: 'OpenAI',
                        onTap: () {
                          Get.toNamed('/setting/api/openai');
                        },
                        bottomRadius: false,
                      ),
                      const Divider(),
                      ListItemCard(
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.asset(
                            'assets/ai/moonshotai.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        title: 'Moonshot AI',
                        onTap: () {
                          Get.toNamed('/setting/api/moonshotai');
                        },
                        topRadius: false,
                        bottomRadius: false,
                      ),
                      const Divider(),
                      ListItemCard(
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.asset(
                            'assets/ai/zhipuai.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                        title: '智谱 AI',
                        onTap: () {
                          Get.toNamed('/setting/api/zhipuai');
                        },
                        topRadius: false,
                      ),
                    ],
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
