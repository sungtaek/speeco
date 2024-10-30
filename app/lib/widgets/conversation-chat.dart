
import 'package:flutter/material.dart';

import '../constants.dart';
import '../theme.dart';

class ConversationChat extends StatefulWidget {
  final List<Message> messages;
  final bool toBottom;

  ConversationChat({Key key, this.messages, this.toBottom = false}) : super(key: key);

  @override
  _ConversationChat createState() => _ConversationChat();
}

class MessageBox {
  Owner owner;
  List<String> sentences;
  MessageBox(Owner owner, String sentence) {
    this.owner = owner;
    this.sentences = <String>[];
    addSentence(sentence);
  }
  void addSentence(String sentence) {
    sentences.add(sentence);
  }
}

class _ConversationChat extends State<ConversationChat> {
  List<MessageBox> _messageBoxes = <MessageBox>[];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (var msg in widget.messages) {
      if (_messageBoxes.isNotEmpty && _messageBoxes.last.owner == msg.owner) {
        _messageBoxes.last.addSentence(msg.text);
      } else {
        _messageBoxes.add(MessageBox(msg.owner, msg.text));
      }
    }
  }

  Widget buildMessageBox(MessageBox messageBox) {
    Color boxColor;
    EdgeInsetsGeometry boxMargin;
    if (messageBox.owner == Owner.USER) {
      boxColor = ThemeColors.primary;
      boxMargin = EdgeInsets.fromLTRB(5, 5, 20, 5);
    } else {
      boxColor = ThemeColors.success;
      boxMargin = EdgeInsets.fromLTRB(20, 5, 5, 5);
    }
    return Container(
        color: boxColor,
        padding: EdgeInsets.all(8),
        margin: boxMargin,
        alignment: Alignment.centerLeft,
        child: Column(
            children: messageBox.sentences.map((s) => Text(s)).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(8),
        controller: _scrollController,
        itemCount: _messageBoxes.length,
        itemBuilder: (BuildContext context, int idx) {
          if (widget.toBottom) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            });
          }
          return buildMessageBox(_messageBoxes[idx]);
        });
  }
}
