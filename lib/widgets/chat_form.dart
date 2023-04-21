import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laotchat/common/appcontext.dart';

class ChatInputForm extends StatelessWidget {
  final Function onChatInput;
  final Function onCancel;
  final Function onRegenerate;
  final bool isReplying;

  ChatInputForm(
      {Key? key,
      required this.onChatInput,
      required this.isReplying,
      required this.onCancel,
      required this.onRegenerate,
      required this.inputController})
      : super(key: key);

  final TextEditingController inputController;
  bool _ctrlKeyPressed = false;
  bool _shiftKeyPressed = false;

  void _handleKeyPress(RawKeyEvent event) {
    if (event.runtimeType == RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.controlLeft || event.logicalKey == LogicalKeyboardKey.controlRight) {
        _ctrlKeyPressed = true;
      } else if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight) {
        _shiftKeyPressed = true;
      } else if ((_ctrlKeyPressed || _shiftKeyPressed) && event.logicalKey == LogicalKeyboardKey.enter) {
        // 当按下 ctrl 或 shift + enter 时换行
        final currentText = inputController.text;
        inputController.text = '$currentText\n';
        inputController.selection = TextSelection.fromPosition(TextPosition(offset: inputController.text.length));
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // 当按下 enter 时直接提交
        if (!_ctrlKeyPressed && !_shiftKeyPressed && inputController.text.isNotEmpty) {
          onChatInput(inputController.text);
          inputController.clear();
        }
      }
    } else if (event.runtimeType == RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.controlLeft || event.logicalKey == LogicalKeyboardKey.controlRight) {
        _ctrlKeyPressed = false;
      } else if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight) {
        _shiftKeyPressed = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String inputHint = AppContext.isDesktop() || AppContext.isBigWindows(context) ? '输入你的问题 Enter 快速提交' : '输入你的问题';
    return Column(
      children: [
        if (isReplying)
          SizedBox(
            width: 240,
            child: TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                onPressed: () {
                  onCancel();
                },
                child: Row(children: const [
                  Icon(
                    size: 18,
                    Icons.stop_circle,
                  ),
                  SizedBox(width: 5),
                  Text('Stop generating', style: TextStyle(fontSize: 16)),
                ])),
          ),
        if (!isReplying)
          SizedBox(
            width: 240,
            child: TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                onPressed: () {
                  onRegenerate();
                },
                child: Row(children: const [
                  Icon(
                    size: 18,
                    Icons.refresh,
                  ),
                  SizedBox(width: 5),
                  Text('Regenerate response', style: TextStyle(fontSize: 16)),
                ])),
          ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1), // 修改这里
            borderRadius: BorderRadius.circular(9),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // 修改这里
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                    // height: AppContext.isDesktop() ? 210 : 120,
                    child: RawKeyboardListener(
                      focusNode: FocusNode(),
                      autofocus: true,
                      onKey: _handleKeyPress,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                          minHeight: 50,
                        ),
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: inputController,
                            maxLines: null,
                            enabled: !isReplying,
                            decoration: InputDecoration(
                              hintText: inputHint,
                              // contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              border: InputBorder.none, // 去掉 TextField 默认的边框
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Column(children: [
                const SizedBox(height: 10),
                if (!isReplying)
                  IconButton(
                    icon: const Icon(Icons.send),
                    // hoverColor: Colors.transparent,
                    splashRadius: 25,
                    onPressed: () {
                      if (inputController.text.isNotEmpty) {
                        onChatInput(inputController.text);
                        inputController.clear();
                      }
                    },
                  ),
                if (isReplying)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                    ),
                  ),
              ])
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Opacity(
            opacity: 0.5,
            child: Text(" ChatGPT may produce inaccurate information about people, places, or facts.",
            style: TextStyle(fontSize: 14)),
          ),
        )
      ],
    );
  }
}
