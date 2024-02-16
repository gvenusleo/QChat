import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/models/collections/chat.dart';
import 'package:qchat/ui/widgets/input_item_card.dart';
import 'package:qchat/ui/widgets/select_item_card.dart';
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
      appBar: AppBar(
        title: const Text('设置对话'),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
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
            const SizedBox(height: 12),
            SelectItemCard(
              title: 'AI 服务',
              selectedItem: _chat.provider,
              items: allAIProviders.map((e) => e.name).toList(),
              onSelected: (value) {
                setState(() {
                  _chat.provider = value;
                  _chat.model = allAIProviders
                      .firstWhere((element) => element.name == value)
                      .models[0];
                  _chat.updatedAt = DateTime.now();
                });
                isar.writeTxnSync(() {
                  isar.chats.putSync(_chat);
                });
              },
            ),
            const SizedBox(height: 12),
            SelectItemCard(
              title: 'AI 模型',
              selectedItem: _chat.model,
              items: allAIProviders
                  .firstWhere(
                    (element) => element.name == _chat.provider,
                  )
                  .models,
              onSelected: (value) {
                setState(() {
                  _chat.model = value;
                  _chat.updatedAt = DateTime.now();
                });
                isar.writeTxnSync(() {
                  isar.chats.putSync(_chat);
                });
              },
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
      ),
    );
  }
}
