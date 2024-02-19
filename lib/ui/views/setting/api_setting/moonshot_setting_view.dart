import 'package:flutter/material.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/ui/widgets/input_item_card.dart';

class MoonshotAISettingView extends StatefulWidget {
  const MoonshotAISettingView({super.key});

  @override
  State<MoonshotAISettingView> createState() => _MoonshotAISettingViewState();
}

class _MoonshotAISettingViewState extends State<MoonshotAISettingView> {
  final TextEditingController _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keyController.text = PrefsHelper.moonshotAIKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('Moonshot AI'),
            ),
            SliverList.list(
              children: [
                InputItemCard(
                  title: 'API Key',
                  controller: _keyController,
                  onChanged: (value) {
                    PrefsHelper.updateMoonshotAIKey(value);
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
