import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/models/collections/chat.dart';
import 'package:qchat/ui/widgets/input_item_card.dart';
import 'package:qchat/ui/widgets/item_card.dart';
import 'package:qchat/ui/widgets/list_item.dart';
import 'package:qchat/ui/widgets/slide_item_card.dart';

class ChatSettingView extends StatefulWidget {
  const ChatSettingView({super.key});

  @override
  State<ChatSettingView> createState() => _ChatSettingViewState();
}

class _ChatSettingViewState extends State<ChatSettingView> {
  late Chat _chat;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chat = Get.arguments;
    _nameController.text = _chat.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('设置对话'),
            ),
            SliverList.list(
              children: [
                InputItemCard(
                  title: '名称',
                  controller: _nameController,
                  onChanged: (value) {
                    _chat.name = value;
                    _chat.updatedAt = DateTime.now();
                    isar.writeTxnSync(() {
                      isar.chats.putSync(_chat);
                    });
                  },
                ),
                ItemCard(
                  title: 'AI 服务',
                  item: InkWell(
                    onTap: _setProvider,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _chat.provider,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                ItemCard(
                  title: 'AI 模型',
                  item: InkWell(
                    onTap: _setModel,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _chat.model,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                SlideItemCard(
                  title: 'Temperature',
                  description: '采样温度，用于控制输出的随机性，取值范围是：(0.0,1.0]，'
                      '值越大，会使输出更随机，更具创造性；值越小，输出会更加稳定或确定。',
                  value: _chat.temperature,
                  minValue: 0.05,
                  maxValue: 1.00,
                  divisions: 19,
                  afterChange: (value) {
                    _chat.temperature = value;
                    _chat.updatedAt = DateTime.now();
                    isar.writeTxnSync(() {
                      isar.chats.putSync(_chat);
                    });
                  },
                ),
                SlideItemCard(
                  title: '对话历史',
                  description: '每次请求附带的历史对话数量。',
                  value: _chat.historyMessages.toDouble(),
                  minValue: 0,
                  maxValue: 20,
                  divisions: 20,
                  afterChange: (value) {
                    _chat.historyMessages = value.toInt();
                    _chat.updatedAt = DateTime.now();
                    isar.writeTxnSync(() {
                      isar.chats.putSync(_chat);
                    });
                  },
                  stringFixed: 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 选择 AI 服务
  Future<void> _setProvider() async {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (int i = 0; i < allAIProviders.length; i++)
                  Column(
                    children: [
                      ListItem(
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.asset(
                            allAIProviders[i].image,
                            width: 28,
                            height: 28,
                          ),
                        ),
                        title: allAIProviders[i].name,
                        trailing: _chat.provider == allAIProviders[i].name
                            ? Icon(
                                Icons.check_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _chat.provider = allAIProviders[i].name;
                            _chat.model = allAIProviders[i].models[0];
                            _chat.updatedAt = DateTime.now();
                          });
                          isar.writeTxnSync(() {
                            isar.chats.putSync(_chat);
                          });
                          Navigator.pop(context);
                        },
                        color: _chat.provider == allAIProviders[i].name
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        topRadius: i == 0,
                        bottomRadius: i == allAIProviders.length - 1,
                      ),
                      if (i != allAIProviders.length - 1) const Divider(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 选择 AI 模型
  Future<void> _setModel() async {
    List<String> modes = allAIProviders
        .firstWhere(
          (element) => element.name == _chat.provider,
        )
        .models;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (int i = 0; i < modes.length; i++)
                  Column(
                    children: [
                      ListItem(
                        title: modes[i],
                        trailing: _chat.model == modes[i]
                            ? Icon(
                                Icons.check_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _chat.model = modes[i];
                            _chat.updatedAt = DateTime.now();
                          });
                          isar.writeTxnSync(() {
                            isar.chats.putSync(_chat);
                          });
                          Navigator.pop(context);
                        },
                        color: _chat.model == modes[i]
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        topRadius: i == 0,
                        bottomRadius: i == modes.length - 1,
                      ),
                      if (i != modes.length - 1) const Divider(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
