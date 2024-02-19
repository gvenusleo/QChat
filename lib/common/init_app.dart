import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qchat/common/font_helper.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/models/collections/chat.dart';
import 'package:qchat/models/collections/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initApp() async {
  logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
      printEmojis: false,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }
  prefs = await SharedPreferences.getInstance();
  FontHelper.readThemeFont();
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [ChatSchema, MessageSchema],
    directory: dir.path,
  );
}
