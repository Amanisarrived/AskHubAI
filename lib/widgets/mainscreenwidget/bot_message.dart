import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:highlight/highlight.dart' show highlight, Node;

class BotMessage extends StatelessWidget {
  final String data;
  const BotMessage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MarkdownBody(
        data: data,
        selectable: true,
        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
          p: const TextStyle(fontSize: 16, color: Colors.black87),
          h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          code: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.white,
            backgroundColor: Colors.transparent,
          ),
          blockquote: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
        builders: {'code': _CodeBuilder(context)},
      ),
    );
  }
}

class _CodeBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  _CodeBuilder(this.context);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final rawText = element.textContent;
    final lang = element.attributes['class']?.replaceFirst(RegExp(r'^language-'), '');

    final spans = (lang != null && lang.isNotEmpty)
        ? _highlightCode(rawText, lang)
        : [TextSpan(text: rawText, style: const TextStyle(color: Colors.white))];

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with language and copy
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
                  tooltip: 'Copy',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: rawText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied')),
                    );
                  },
                ),
              ],
            ),
          ),
          // Code text area
          Container(
            padding: const EdgeInsets.all(12),
            child: SelectableText.rich(
              TextSpan(children: spans),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _highlightCode(String source, String lang) {
    final nodes = highlight.parse(source, language: lang).nodes ?? [];
    return nodes.map((n) => _convertNode(n)).toList();
  }

  InlineSpan _convertNode(Node node) {
    if (node.value != null) {
      return TextSpan(
        text: node.value,
        style: TextStyle(
          color: _colorFor(node.className),
        ),
      );
    }

    return TextSpan(
      children: (node.children ?? []).map((child) => _convertNode(child)).toList(),
      style: TextStyle(
        color: _colorFor(node.className),
      ),
    );
  }

  Color _colorFor(String? className) {
    switch (className) {
      case 'keyword':
        return const Color(0xFFc792ea);
      case 'string':
        return const Color(0xFFecc48d);
      case 'number':
        return const Color(0xFFf78c6c);
      case 'comment':
        return const Color(0xFF616161);
      case 'function':
        return const Color(0xFF82aaff);
      case 'class':
        return const Color(0xFFffcb6b);
      default:
        return Colors.white;
    }
  }
}
