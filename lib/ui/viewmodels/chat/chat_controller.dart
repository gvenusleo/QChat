import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/common/prefs_helper.dart';
import 'package:qchat/services/moonshotai.dart';
import 'package:qchat/services/openai.dart';
import 'package:qchat/services/zhipuai.dart';
import 'package:qchat/models/collections/chat.dart';
import 'package:qchat/models/collections/message.dart';

class ChatController extends GetxController {
  // 会话列表
  RxList<Chat> chats = <Chat>[].obs;
  // 消息列表
  RxList<Message> messages = <Message>[].obs;
  // 当前会话
  Rx<Chat> currentChat = Chat().obs;
  // 是否正在请求
  RxBool isRequesting = false.obs;

  // 初始化数据
  @override
  void onInit() {
    super.onInit();
    updateChats();
  }

  // 更新会话列表
  void updateChats() {
    chats.value = isar.chats.where().sortByUpdatedAtDesc().findAllSync();
    if (chats.isNotEmpty) {
      currentChat.value = chats.first;
    } else {
      Chat chat = Chat()
        ..name = '新对话'
        ..provider = 'OpenAI'
        ..model = 'gpt-4'
        ..temperature = PrefsHelper.defaultTemperature
        ..historyMessages = PrefsHelper.defaultHistoryMessages
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      isar.writeTxnSync(() {
        isar.chats.putSync(chat);
      });
      chats.add(chat);
      currentChat.value = chat;
    }
    updateMessages();
  }

  // 更新消息列表
  void updateMessages() {
    messages.value = isar.messages
        .where()
        .filter()
        .chat((q) => q.idEqualTo(currentChat.value.id))
        .sortByTimeDesc()
        .findAllSync();
  }

  // 更新当前会话
  void updateCurrentChat(Chat chat) {
    currentChat.value = chat;
    updateMessages();
  }

  // 创建新会话
  void createChat() {
    Chat chat = Chat()
      ..name = '新对话'
      ..provider = 'OpenAI'
      ..model = 'gpt-4'
      ..temperature = PrefsHelper.defaultTemperature
      ..historyMessages = PrefsHelper.defaultHistoryMessages
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    isar.writeTxnSync(() {
      isar.chats.putSync(chat);
    });
    chats.insert(0, chat);
    currentChat.value = chat;
    updateMessages();
  }

  // 删除当前会话
  void deleteCurrentChat() {
    isar.writeTxnSync(() {
      isar.messages.deleteAllSync(
        List.generate(
          messages.length,
          (index) => messages[index].id,
        ),
      );
      isar.chats.deleteSync(currentChat.value.id);
    });
    chats.remove(currentChat.value);
    if (chats.isNotEmpty) {
      currentChat.value = chats.first;
    } else {
      Chat chat = Chat()
        ..name = '新对话'
        ..provider = 'OpenAI'
        ..model = 'gpt-4'
        ..temperature = PrefsHelper.defaultTemperature
        ..historyMessages = PrefsHelper.defaultHistoryMessages
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();
      isar.writeTxnSync(() {
        isar.chats.putSync(chat);
      });
      chats.add(chat);
      currentChat.value = chat;
    }
    updateMessages();
  }

  // 开始请求
  void startRequest(String text) {
    isRequesting.value = true;
    final botMsg = Message()
      ..role = 'bot'
      ..chat.value = currentChat.value
      ..content = '$text︎●'
      ..time = DateTime.now();
    messages.insert(0, botMsg);
  }

  // 请求中
  void requesting(String text) {
    final botMsg = Message()
      ..role = 'bot'
      ..chat.value = currentChat.value
      ..content = '$text︎●'
      ..time = DateTime.now();
    messages[0] = botMsg;
  }

  // 请求完成
  void finishRequest(String text) {
    final botMsg = Message()
      ..role = 'bot'
      ..chat.value = currentChat.value
      ..content = text
      ..time = DateTime.now();
    messages[0] = botMsg;
    isar.writeTxnSync(() {
      isar.messages.putSync(botMsg);
    });
    isRequesting.value = false;
  }

  // 请求响应
  Future<void> response(String text) async {
    Message newMsg = Message()
      ..role = 'user'
      ..chat.value = currentChat.value
      ..content = text
      ..time = DateTime.now();
    isar.writeTxnSync(() async {
      isar.messages.putSync(newMsg);
    });
    messages.insert(0, newMsg);
    List<Message> msgs = messages
        .sublist(
            0,
            currentChat.value.historyMessages + 1 < messages.length
                ? currentChat.value.historyMessages + 1
                : messages.length)
        .reversed
        .toList();
    try {
      switch (currentChat.value.provider) {
        case 'OpenAI':
          await OpenAIBot.get(
            msgs,
            currentChat.value,
            startRequest,
            requesting,
            finishRequest,
          );
          break;
        case 'Moonshot AI':
          await MoonshotAIBot.get(
            msgs,
            currentChat.value,
            startRequest,
            requesting,
            finishRequest,
          );
          break;
        case '智谱 AI':
          await ZhipuaiBot.get(
            msgs,
            currentChat.value,
            startRequest,
            requesting,
            finishRequest,
          );
          break;
      }
    } catch (e) {
      logger.e(e.toString());
      isRequesting.value = false;
      updateMessages();
      Fluttertoast.showToast(msg: '请求失败');
    }
  }
}
