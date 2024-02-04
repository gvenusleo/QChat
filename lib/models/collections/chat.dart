import 'package:isar/isar.dart';

part 'chat.g.dart';

@collection
class Chat {
  Id id = Isar.autoIncrement;
  late String name;
  late String provider;
  late String model;
  late double temperature;
  late int historyMessages;
  late DateTime createdAt;
  late DateTime updatedAt;
}
