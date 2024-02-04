import 'package:flutter/material.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/ui/widgets/input_item_card.dart';

class ZhipuAISettingView extends StatefulWidget {
  const ZhipuAISettingView({super.key});

  @override
  State<ZhipuAISettingView> createState() => _ZhipuAISettingViewState();
}

class _ZhipuAISettingViewState extends State<ZhipuAISettingView> {
  final TextEditingController _keyController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _keyController.text = prefs.getString('zhipuAIKey') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('智谱 AI'),
            ),
            SliverList.list(
              children: [
                InputItemCard(
                  title: 'API Key',
                  controller: _keyController,
                  onChanged: (value) {
                    prefs.setString('zhipuAIKey', value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
