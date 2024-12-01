
import 'package:flutter/material.dart';

class BoldableText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final bool isSelectable;

  const BoldableText(this.text,
      {Key key, this.isSelectable = false, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> children = [];
    final List<String> split = text.split('**');
    for (int i = 0; i < split.length; i++) {
      if (i % 2 == 0) {
        children.add(TextSpan(text: split[i], style: style));
      } else {
        children.add(TextSpan(
            text: split[i],
            style: (style ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.bold)));
      }
    }
    if (isSelectable) {
      return SelectableText.rich(
        TextSpan(children: children),
        style: style,
        textAlign: textAlign,
      );
    }
    return Text.rich(
      TextSpan(children: children),
      style: style,
      textAlign: textAlign,
    );
  }
}