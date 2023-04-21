import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gptchat/common/appcontext.dart';

class ChatInputForm extends StatelessWidget {
  final Function onChatInput;
  final Function onCancel;
  final Function onRegenerate;
  final bool isReplying;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController inputController = TextEditingController();

  ChatInputForm(
      {Key? key,
      required this.onChatInput,
      required this.isReplying,
      required this.onCancel,
      required this.onRegenerate})
      : super(key: key);


  bool _isControlOrShiftKeyPressed(RawKeyEvent event) {
    return event.isControlPressed || event.isShiftPressed;
  }

  @override
  Widget build(BuildContext context) {
    String inputHint = '输入你的问题';
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
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 300,
                        minHeight: 50,
                      ),
                      child: SingleChildScrollView(
                        child: RawKeyboardListener(
                          focusNode: _focusNode,
                          onKey: (RawKeyEvent event) {
                            if (event.runtimeType == RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.enter &&
                                _isControlOrShiftKeyPressed(event)) {
                              // Insert a new line when Ctrl or Shift is pressed along with Enter
                              inputController.value = inputController.value.copyWith(
                                text: inputController.text + '\n',
                                selection: TextSelection.collapsed(offset: inputController.text.length + 1),
                                composing: TextRange.empty,
                              );
                            } else if (event.runtimeType == RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.enter &&
                                !_isControlOrShiftKeyPressed(event)) {
                              // Submit the text when Enter is pressed without Ctrl or Shift
                              onChatInput(inputController.text);
                              inputController.clear();
                            }
                          },
                          child: TextField(
                            controller: inputController,
                            maxLines: null,
                            enabled: !isReplying,
                            keyboardType: TextInputType.multiline,
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
