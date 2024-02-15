import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qchat/common/global.dart';
import 'package:qchat/ui/viewmodels/chat/chat_controller.dart';
import 'package:qchat/ui/widgets/msg_card.dart';
import 'package:qchat/ui/widgets/scroll_to_bottom_buttom.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatController c = Get.put(ChatController());

  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  // 可以滚动到底部
  bool _canScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.25,
      drawer: buildDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => c.messages.isEmpty
                ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        allAIProviders
                            .firstWhere(
                                (e) => e.name == c.currentChat.value.provider)
                            .image,
                        width: 36,
                        height: 36,
                      ),
                    ),
                  )
                : buildMsgList()),
          ),
          buildInputBar(),
        ],
      ),
    );
  }

  Widget buildMsgList() {
    return Stack(
      children: [
        Obx(() => ListView.builder(
              reverse: true,
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemCount: c.messages.length,
              itemBuilder: (context, index) {
                return MsgCard(
                  msg: c.messages[index],
                  reRequest: _request,
                );
              },
            )),
        _canScrollToBottom
            ? ScrollToBottomButton(scrollController: _scrollController)
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget buildInputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                margin: const EdgeInsets.only(right: 8),
                clipBehavior: Clip.antiAlias,
                child: Obx(() => TextField(
                      enabled: !c.isRequesting.value,
                      controller: _inputController,
                      focusNode: _focusNode,
                      minLines: 1,
                      maxLines: 10,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceVariant,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        suffixIcon: c.isRequesting.value
                            ? Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  strokeWidth: 2,
                                ),
                              )
                            : null,
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                          maxHeight: 24,
                          maxWidth: 36,
                        ),
                      ),
                    )),
              ),
            ),
            IconButton.filled(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              onPressed: () async {
                String text = _inputController.text.trim();
                _inputController.clear();
                _focusNode.unfocus();
                if (text.isNotEmpty) {
                  _request(text);
                }
              },
              icon: const Icon(Icons.arrow_upward_rounded),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                c.currentChat.value.name,
                style: const TextStyle(fontSize: 18),
              )),
          Obx(() => Text(
                c.currentChat.value.model,
                style: const TextStyle(fontSize: 12),
              )),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _createdChat,
          icon: const Icon(Icons.playlist_add_rounded),
        ),
        PopupMenuButton(
          position: PopupMenuPosition.under,
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () async {
                  await Get.toNamed('chat/setting', arguments: c.currentChat);
                  c.updateChats();
                  _scrollController.addListener(() => _onScroll());
                },
                child: const Row(
                  children: [
                    Icon(Icons.tune_outlined),
                    SizedBox(width: 12),
                    Text('设置对话'),
                  ],
                ),
              ),
              const PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined),
                    SizedBox(width: 12),
                    Text('舍弃上下文'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        icon: const Icon(Icons.delete_outline_rounded),
                        title: const Text('删除对话'),
                        content: const Text('确定要删除所有对话内容吗？'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              c.deleteCurrentChat();
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline_rounded),
                    SizedBox(width: 12),
                    Text('删除对话'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Text(
                'QChat',
                style: TextStyle(fontSize: 28),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() => ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    children: c.chats.map((e) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(48),
                          color: c.currentChat.value == e
                              ? Theme.of(context).colorScheme.secondaryContainer
                              : null,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(
                              allAIProviders
                                  .firstWhere(
                                    (element) => element.name == e.provider,
                                  )
                                  .image,
                              width: 28,
                              height: 28,
                            ),
                          ),
                          title: Text(e.name),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          visualDensity: VisualDensity.comfortable,
                          onTap: () {
                            if (c.isRequesting.value) {
                              Fluttertoast.showToast(msg: '正在请求，请稍后');
                              return;
                            }
                            Navigator.pop(context);
                            c.updateCurrentChat(e);
                          },
                        ),
                      );
                    }).toList(),
                  )),
            ),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 18),
                Expanded(
                  child: InkWell(
                    onTap: _createdChat,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withAlpha(150),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.playlist_add_rounded),
                          Text(
                            '新建对话',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/search');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withAlpha(150),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.search_rounded),
                          Text(
                            '搜索对话',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.toNamed('/setting');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withAlpha(150),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(48),
                        child: Image.asset(
                          'assets/user.png',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'YOU',
                        style: TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      const Icon(Icons.more_horiz_outlined),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// 初始化数据
  void initData() {
    c.updateChats();
    // 延迟 300 毫秒后获取焦点
    Future.delayed(const Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
  }

  /// 创建新对话
  Future<void> _createdChat() async {
    c.createChat();
    await Get.toNamed('chat/setting', arguments: c.currentChat.value);
    initData();
  }

  /// 滚动监听
  Future<void> _onScroll() async {
    bool topReached = _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange;
    if (topReached) {
      showScrollToBottom();
    } else if (_scrollController.offset > 20) {
      showScrollToBottom();
    } else {
      hideScrollToBottom();
    }
  }

  /// 显示滚动到底部按钮
  void showScrollToBottom() {
    if (!_canScrollToBottom) {
      setState(() {
        _canScrollToBottom = true;
      });
    }
  }

  /// 隐藏滚动到底部按钮
  void hideScrollToBottom() {
    if (_canScrollToBottom) {
      setState(() {
        _canScrollToBottom = false;
      });
    }
  }

  /// 请求响应
  Future<void> _request(String text) async {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    c.response(text);
  }
}
