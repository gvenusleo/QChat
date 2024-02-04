import 'package:isar/isar.dart';
import 'package:qchat/models/collections/chat.dart';

part 'message.g.dart';

@collection
class Message {
  Id id = Isar.autoIncrement;
  late String role;
  final IsarLink<Chat> chat = IsarLink<Chat>();
  late String content;
  late DateTime time;
}
