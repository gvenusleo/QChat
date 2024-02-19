import 'package:flutter/material.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/ui/widgets/input_item_card.dart';

class OpenAISettingView extends StatefulWidget {
  const OpenAISettingView({super.key});

  @override
  State<OpenAISettingView> createState() => _OpenAISettingViewState();
}

class _OpenAISettingViewState extends State<OpenAISettingView> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keyController.text = PrefsHelper.openAIKey;
    _baseUrlController.text = PrefsHelper.openAIBaseUrl;
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
                    PrefsHelper.updateOpenAIKey(value);
                  },
                ),
                const SizedBox(height: 12),
                InputItemCard(
                  title: 'Base URL',
                  controller: _baseUrlController,
                  onChanged: (value) {
                    PrefsHelper.updateOpenAIBaseUrl(value);
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
