import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/common/global.dart';

class ThemeSettingView extends StatelessWidget {
  ThemeSettingView({super.key});

  final List<String> _themeModes = ['跟随系统', '浅色模式', '深色模式'];
  final List<IconData> _themeIcons = [
    Icons.android_rounded,
    Icons.wb_sunny_rounded,
    Icons.nights_stay_rounded,
  ];

  final _mode = (prefs.getInt('themeMode') ?? 0).obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar.large(
              title: Text('外观设置'),
            ),
            SliverList.list(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withAlpha(150),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '主题背景',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++) ...[
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  prefs.setInt('themeMode', i);
                                  _mode.value = i;
                                  Get.changeThemeMode([
                                    ThemeMode.system,
                                    ThemeMode.light,
                                    ThemeMode.dark
                                  ][i]);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Obx(() => Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _mode.value == i
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            _themeIcons[i],
                                            color: _mode.value == i
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                          ),
                                          Text(
                                            _themeModes[i],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: _mode.value == i
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .outline),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            if (i != 2) const SizedBox(width: 12),
                          ],
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DynamicColorBuilder(
                    builder: (ColorScheme? light, ColorScheme? dark) {
                      return SwitchListTile(
                        value: prefs.getBool('useDynamicColor') ?? true,
                        onChanged: (value) {
                          // useDynamicColor.value = value;
                          prefs.setBool('useDynamicColor', value);
                          Get.forceAppUpdate();
                        },
                        title: const Text('使用动态颜色'),
                        subtitle: const Text('根据手机壁纸自动调整前景颜色'),
                        tileColor: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withAlpha(150),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
