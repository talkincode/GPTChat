import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gptchat/common/appcontext.dart';
import 'package:gptchat/common/historys.dart';
import 'package:gptchat/common/websse.dart';
import 'package:gptchat/common/models.dart';
import 'package:gptchat/widgets/chat_form.dart';
import 'package:gptchat/widgets/chat_sidebar.dart';
import 'package:gptchat/widgets/chat_widget.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isReplying = false;
  String conversation = AppContext.newUUID();
  String lastInput = "";

  MyEventSource? eventSource;

  _ChatScreenState();

  final List<ChatMessageWidget> messages = [];
  final List<Conversation> conversations = [];

  final ScrollController _scrollController = ScrollController();

  // final TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    AppContext.dbManager.listConversations().then((value) {
      conversations.clear();
      conversations.addAll(value);
      if (conversations.isNotEmpty) {
        conversation = conversations.first.conversation;
      }
      _loadHistory();
    });
  }

  void _loadHistory() {
    messages.clear();
    HistoryUtil.reloadChatHistorys(conversation, 50).then((value) {
      var historys = HistoryUtil.getChatMessages();
      for (var hmsg in historys) {
        var msg = ChatMessageItem(
            hmsg.id, hmsg.content ?? "", hmsg.role == "user" ? ChatMessageType.sent : ChatMessageType.received);
        messages.add(ChatMessageWidget(message: msg));
      }
      setState(() {
        _isReplying = false;
      });
      // 延时1秒执行
      // Future.delayed(const Duration(milliseconds: 500), () {
      //   // _scrollToBottom();
      //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // });
    });
  }

  @override
  void dispose() {
    try {
      eventSource?.close();
    } catch (e) {
      print(e);
    } finally {
      eventSource = null;
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _onReply(data) {
    Map<String, dynamic> jsonData = jsonDecode(data);
    OpenaiChatMessage reponseMessage = OpenaiChatMessage.fromJson(jsonData);
    if (reponseMessage.result != null) {
      if (messages.isEmpty || messages.last.message.type == ChatMessageType.sent) {
        if (mounted) {
          setState(() {
            _isReplying = true;
          });
        }

        ChatMessageItem newMessage = ChatMessageItem(
            AppContext.newUUID(), reponseMessage.result?.content?.trimLeft() ?? "", ChatMessageType.received);
        messages.add(ChatMessageWidget(message: newMessage));
      } else if (reponseMessage.status == "done" || reponseMessage.status == "error") {
        messages.last.message.appendMessage(reponseMessage.result?.content ?? "");

        HistoryUtil.addChatMessage(ChatCompletionMessage(
          role: "assistant",
          content: messages.last.message.messageString(),
          id: messages.last.message.key,
          conversation: conversation,
        ));
        if (mounted) {
          setState(() {
            _isReplying = false;
          });
        }
      } else {
        messages.last.message.appendMessage(reponseMessage.result?.content ?? "");
      }
      _scrollToBottom();
    }
  }

  /// ///////////////////////////////////////////
  /// Send a message to the chatbot
  /// @param msg
  /// ///////////////////////////////////////////
  Future<void> _sendChatMessage(key, msg) async {
    var apiRequest = OpenaiChatMessage(
      status: "start",
      event: AppContext.chatEvent,
      msgid: AppContext.newUUID(),
      time: DateTime.now().millisecondsSinceEpoch,
    );
    var ccmsg = ChatCompletionMessage(role: "user", content: msg, id: key, conversation: conversation);
    var contextMessages = HistoryUtil.getLatestChatMessages();
    contextMessages.add(ccmsg);
    apiRequest.messages = contextMessages;

    // add history
    HistoryUtil.addChatMessage(ccmsg);

    ///
    var apiurl = "${AppContext.gptapi}/chat/sse";
    eventSource = await MyEventSource.connect(Uri.parse(apiurl), await AppContext.getUserToken(), apiRequest);
    eventSource?.stream.listen(
        (event) {
          _onReply(event);
        },
        onError: _onError,
        onDone: () {
          print('SSE Stream Connection closed');
        });
  }

  void _onError(error) {
    if (!error.toString().contains("Connection closed ")) {
      String errmsg = error.toString();
      if (error.toString().contains(AppContext.noLogin)) {
        errmsg = "无效的 APIKey";
      } else if (error.toString().contains(AppContext.noSubs)) {
        errmsg = "没有足够的配额";
      }
      messages.add(ChatMessageWidget(message: ChatMessageItem(AppContext.newUUID(), errmsg, ChatMessageType.received)));
    }
    setState(() {
      _isReplying = false;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollToBottom();
    });
  }

  void _onFormInput(String msg) {
    lastInput = msg;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    var key = AppContext.newUUID();
    setState(() {
      _isReplying = true;
      messages.add(ChatMessageWidget(message: ChatMessageItem(key, msg, ChatMessageType.sent)));
      _scrollToBottom();
    });
    _sendChatMessage(key, msg);
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollToBottom();
    });
  }

  /// scroll to bottom
  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.linear,
      );
    });
  }

  /// 对话改变事件
  void _onConversationChanged(String value) {
    if (_isReplying) {
      AppContext.showMessageBox(context, "正在回复中，请稍后再试", false);
      return;
    }
    setState(() {
      conversation = value;
    });
    _loadHistory();
  }

  /// 删除当前对话事件
  void _onConversationRemoved() {
    if (_isReplying) {
      AppContext.showMessageBox(context, "正在回复中，请稍后再试", false);
      return;
    }
    AppContext.confrimBox(context, "确定要删除当前对话吗？").then((value) {
      if (value) {
        AppContext.dbManager.deleteConversation(conversation).then((code) {
          if (code != 200) {
            AppContext.showMessageBox(context, "删除对话失败", true);
            return;
          }
          conversations.removeWhere((element) => element.conversation == conversation);
          HistoryUtil.clearChatHistorys();
          messages.clear();
          if (conversations.isNotEmpty) {
            setState(() {
              conversation = conversations.first.conversation;
            });
            _loadHistory();
          } else {
            setState(() {
              conversation = AppContext.newUUID();
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppContext.isBigWindows(context))
          ? null
          : AppBar(
              title: const Text("ChatGPT"),
              actions: const [],
            ),
      body: Row(
        children: [
          Visibility(
            visible: AppContext.isBigWindows(context),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              width: 270,
              child: Column(
                children: [
                  Expanded(
                    child: ChatSidebar(
                        conversations: conversations,
                        conversation: conversation,
                        onChanged: (value) {
                          _onConversationChanged(value);
                        },
                        onConversationRemovePressed: () {
                          _onConversationRemoved();
                        },
                        onLogout: () {
                          AppContext.confrimBox(context, "即将退出并清除客户端信息").then((value) {
                            if (value) {
                              AppContext.clearAccountata();
                              setState(() {
                                conversations.clear();
                                messages.clear();
                                conversation = "";
                              });
                            }
                          });
                        }),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: messages.map((item) {
                        return item;
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  padding: AppContext.isBigWindows(context)
                      ? const EdgeInsets.symmetric(horizontal: 70, vertical: 20)
                      : const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ChatInputForm(
                    onChatInput: _onFormInput,
                    onRegenerate: () {
                      if (lastInput != "") {
                        _onFormInput(lastInput);
                      }
                    },
                    onCancel: () {
                      eventSource?.close();
                      setState(() {
                        _isReplying = false;
                      });
                    },
                    isReplying: _isReplying,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
