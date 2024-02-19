import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:qchat/common/global.dart';
import 'package:qchat/models/collections/message.dart';
import 'package:qchat/plugins/latex_block_syntax.dart';
import 'package:qchat/plugins/latex_element_builder.dart';
import 'package:qchat/plugins/latex_inline_syntax.dart';

class MsgCard extends StatefulWidget {
  final Message msg;
  final Function(String) reRequest;
  const MsgCard({
    super.key,
    required this.msg,
    required this.reRequest,
  });

  @override
  State<MsgCard> createState() => _MsgCardState();
}

class _MsgCardState extends State<MsgCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: GestureDetector(
        onLongPressStart: (details) {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx - 150,
              details.globalPosition.dy,
              100000,
              100000,
            ),
            items: [
              PopupMenuItem(
                value: 'copy',
                child: const Row(
                  children: [
                    Icon(Icons.copy_all_rounded),
                    SizedBox(width: 12),
                    Text('复制内容'),
                  ],
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.msg.content));
                },
              ),
              PopupMenuItem(
                value: 'delete',
                child: const Row(
                  children: [
                    Icon(Icons.text_snippet_rounded),
                    SizedBox(width: 12),
                    Text('选择文字'),
                  ],
                ),
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (context) {
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: SafeArea(
                          child: SelectableText(
                            widget.msg.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              if (widget.msg.role == 'user')
                PopupMenuItem(
                  value: 'delete',
                  child: const Row(
                    children: [
                      Icon(Icons.autorenew_rounded),
                      SizedBox(width: 12),
                      Text('重新请求'),
                    ],
                  ),
                  onTap: () async {
                    await widget.reRequest(widget.msg.content);
                  },
                ),
            ],
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          width: double.infinity,
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.msg.role == 'user'
                          ? 'assets/user.png'
                          : allAIProviders
                              .firstWhere((e) =>
                                  e.name == widget.msg.chat.value!.provider)
                              .image,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.msg.role == 'user'
                        ? 'YOU'
                        : allAIProviders
                            .firstWhere((e) =>
                                e.name == widget.msg.chat.value!.provider)
                            .name
                            .toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Markdown(
                data: widget.msg.content,
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 32),
                physics: const NeverScrollableScrollPhysics(),
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    fontSize: 16,
                  ),
                  code: TextStyle(
                    fontSize: 14,
                    fontFamily: 'FiraCode',
                    fontFamilyFallback: [
                      Theme.of(context).textTheme.bodyLarge?.fontFamily ?? ""
                    ],
                    backgroundColor: Colors.transparent,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withAlpha(150),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withAlpha(150),
                    border: Border(
                      left: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  blockquotePadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                builders: {
                  'latex': LatexElementBuilder(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                },
                extensionSet: md.ExtensionSet(
                  [LatexBlockSyntax()],
                  [LatexInlineSyntax()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
