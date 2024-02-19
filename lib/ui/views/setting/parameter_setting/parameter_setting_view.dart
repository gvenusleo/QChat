import 'package:flutter/material.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/ui/widgets/slide_item_card.dart';

class ParameterSettingView extends StatefulWidget {
  const ParameterSettingView({super.key});
  @override
  State<ParameterSettingView> createState() => _ParameterSettingViewState();
}

class _ParameterSettingViewState extends State<ParameterSettingView> {
  final double _tem = PrefsHelper.defaultTemperature;
  final int _his = PrefsHelper.defaultHistoryMessages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('默认参数'),
            ),
            SliverList.list(
              children: [
                SlideItemCard(
                  title: 'Temperature',
                  description: '采样温度，用于控制输出的随机性，取值范围是：(0.0,1.0]，'
                      '值越大，会使输出更随机，更具创造性；值越小，输出会更加稳定或确定。',
                  value: _tem,
                  minValue: 0.05,
                  maxValue: 1.0,
                  divisions: 19,
                  afterChange: (value) async {
                    PrefsHelper.updateDefaultTemperature(value);
                  },
                ),
                const SizedBox(height: 12),
                SlideItemCard(
                  title: '对话历史',
                  description: '每次请求附带的历史对话数量。',
                  value: _his.toDouble(),
                  minValue: 0,
                  maxValue: 20,
                  divisions: 20,
                  afterChange: (value) async {
                    PrefsHelper.updateDefaultHistoryMessages(value.toInt());
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
}
