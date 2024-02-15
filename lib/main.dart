import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:qchat/common/init_app.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/ui/routes.dart';
import 'package:qchat/ui/views/chat/chat_view.dart';
import 'package:qchat/common/theme.dart';

Future<void> main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale("en"), Locale("zh")],
          theme: buildLightTheme(lightColorScheme),
          darkTheme: buildDarkTheme(darkColorScheme),
          themeMode: [
            ThemeMode.system,
            ThemeMode.light,
            ThemeMode.dark
          ][PrefsHelper.themeMode],
          getPages: AppRputes.routes,
          defaultTransition: Transition.cupertino,
          home: const ChatView(),
        );
      },
    );
  }
}
