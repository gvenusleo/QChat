/// https://github.com/xushengs/flutter_markdown_latex/blob/main/lib/src/latex_inline_syntax.dart
// ignore_for_file: dangling_library_doc_comments

import 'package:markdown/markdown.dart';

class LatexInlineSyntax extends InlineSyntax {
  LatexInlineSyntax()
      : super(
            r'(\${1,2})(?!\$)((?:\\.|[^\\\n])*?(?:\\.|[^\\\n\$]))\1(?=[\s?!\.,:？！。，：]|$)');

  @override
  bool onMatch(InlineParser parser, Match match) {
    Element element = Element.text('latex', match[2] ?? '');
    element.attributes['displayMode'] =
        match[1]?.length == 2 ? 'true' : 'false';
    parser.addNode(element);
    return true;
  }
}
