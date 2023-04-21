import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laotchat/common/appcontext.dart';
import 'package:share_plus/share_plus.dart';

enum ChatMessageType { sent, received }

class ChatMessageItem {
  ValueNotifier<List<String>>? texts;
  final ChatMessageType type;
  final String? key;

  ChatMessageItem(this.key, String msg, this.type) {
    texts = ValueNotifier<List<String>>([msg]);
  }

  void appendMessage(String msg) {
    texts!.value = List<String>.from(texts!.value)..add(msg);
  }

  String messageString() {
    return texts!.value.join('').trimLeft();
  }
}

class ChatMessageWidget extends StatefulWidget {
  final ChatMessageItem message;

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();

  const ChatMessageWidget({Key? key, required this.message}) : super(key: key);
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.message.type == ChatMessageType.received
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.10)
            : Theme.of(context).colorScheme.secondary.withOpacity(0.01),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message.type == ChatMessageType.received)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/laotchat_avatar.png'),
                ),
              ),
            if (widget.message.type == ChatMessageType.sent)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white30,
                  backgroundImage: AssetImage('assets/images/avatar14.png'),
                ),
              ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ValueListenableBuilder<List<String>>(
                    valueListenable: widget.message.texts!,
                    builder: (context, texts, child) {
                      var txtmessage = texts.join('').trimLeft();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            txtmessage,
                            maxLines: null,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto', // 字体家族
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AiSpellNotification extends Notification {
  final Map<String, dynamic> item;

  AiSpellNotification(this.item);
}
