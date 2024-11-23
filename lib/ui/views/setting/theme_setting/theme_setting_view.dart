import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qchat/ui/viewmodels/theme_setting/theme_setting_controller.dart';
import 'package:qchat/ui/widgets/item_card.dart';

class ThemeSettingView extends StatelessWidget {
  ThemeSettingView({super.key});

  final List<String> _themeModes = ['跟随系统', '浅色模式', '深色模式'];
  final List<IconData> _themeIcons = [
    Icons.android_rounded,
    Icons.wb_sunny_rounded,
    Icons.nights_stay_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    ThemeSettingController c = Get.put(ThemeSettingController());
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
                ItemCard(
                  title: '主题背景',
                  item: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              c.updateThemeMode(i);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Obx(
                              () => Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: c.themeMode.value == i
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      _themeIcons[i],
                                      color: c.themeMode.value == i
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
                                          color: c.themeMode.value == i
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (i != 2) const SizedBox(width: 12),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DynamicColorBuilder(
                    builder: (ColorScheme? light, ColorScheme? dark) {
                      return SwitchListTile(
                        value: c.useDynamicColor.value,
                        onChanged: (value) {
                          c.updateDynamicColor(value);
                        },
                        title: const Text('使用动态颜色'),
                        subtitle: const Text('根据手机壁纸自动调整前景颜色'),
                        tileColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withAlpha(150),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      );
                    },
                  ),
                ),
                ItemCard(
                  title: '全局字体',
                  item: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (String font in c.fonts) ...[
                              InkWell(
                                onTap: () async {
                                  c.updateThemeFont(font);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: double.infinity,
                                  height: 48,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: c.themeFont.value == font
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .outline,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        font.split('.').first,
                                        style: TextStyle(
                                          fontFamily: font,
                                          fontSize: 16,
                                          color: c.themeFont.value == font
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                        ),
                                      ),
                                      if (font != '默认字体')
                                        IconButton(
                                          onPressed: () {
                                            c.deleteFont(font);
                                          },
                                          icon: Icon(
                                            Icons.delete_forever_outlined,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: c.loadLocalFont,
                          icon: const Icon(Icons.add_outlined),
                          label: const Text('导入字体'),
                        ),
                      ),
                    ],
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
