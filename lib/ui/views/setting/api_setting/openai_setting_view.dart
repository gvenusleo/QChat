import 'package:flutter/material.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/ui/widgets/input_item_card.dart';

class OpenAISettingView extends StatefulWidget {
  const OpenAISettingView({super.key});

  @override
  State<OpenAISettingView> createState() => _OpenAISettingViewState();
}

class _OpenAISettingViewState extends State<OpenAISettingView> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _serverController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keyController.text = prefs.getString('openAIKey') ?? '';
    _serverController.text =
        prefs.getString('openAIServer') ?? 'https://api.openai.com';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('OpenAI'),
            ),
            SliverList.list(
              children: [
                InputItemCard(
                  title: 'API Key',
                  controller: _keyController,
                  onChanged: (value) {
                    prefs.setString('openAIKey', value);
                  },
                ),
                const SizedBox(height: 12),
                InputItemCard(
                  title: 'API Server',
                  controller: _serverController,
                  onChanged: (value) {
                    prefs.setString('openAIServer', value);
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
