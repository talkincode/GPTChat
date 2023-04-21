import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laotchat/common/appcontext.dart';
import 'package:laotchat/common/models.dart';
import 'package:laotchat/widgets/apiauth.dart';
import 'package:laotchat/widgets/usage.dart';

class ChatSidebar extends StatefulWidget {
  List<Conversation> conversations;
  String conversation;
  final Function(String) onChanged;
  final Function() onConversationRemovePressed;

  ChatSidebar({
    Key? key,
    required this.conversations,
    required this.conversation,
    required this.onChanged,
    required this.onConversationRemovePressed,
  }) : super(key: key);

  @override
  _ChatSidebarState createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        // borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: [
        TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
            onPressed: () {
              var newchatid = AppContext.newUUID();
              var conv = Conversation(conversation: newchatid, name: '新对话', roleid: "default");
              AppContext.dbManager.createConversation(conv);
              widget.conversations.add(conv);
              widget.onChanged(newchatid);
            },
            child: Row(children: const [
              Icon(
                size: 18,
                Icons.add,
                color: Colors.white70,
              ),
              SizedBox(width: 5),
              Text('New chat', style: TextStyle(fontSize: 18, color: Colors.white)),
            ])),
        const Divider(color: Colors.white38, thickness: 1),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            width: 320,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.05), width: 1),
            ),
            child: ListView.builder(
              itemCount: widget.conversations.length,
              itemBuilder: (BuildContext context, int index) {
                var item = widget.conversations[index];
                return TextButton(
                  onPressed: () {
                    widget.onChanged(item.conversation);
                  },
                  child: Row(children: [
                    Expanded(
                        child: Tooltip(
                          message: item.name,
                          child: Text(AppContext.subString(item.name, 20),
                              style: const TextStyle(fontSize: 16, color: Colors.white70)),
                        )),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            showConversationEditForm(context, item.conversation, item.name, (newv){
                              setState(() {
                                item.name = newv;
                              });
                            });
                          },
                          icon: const Icon(
                            size: 18,
                            Icons.edit,
                            color: Colors.white70,
                          )),
                    ),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        splashRadius: 20,
                          onPressed: () {
                            widget.onConversationRemovePressed();
                          },
                          icon: const Icon(
                            size: 18,
                            Icons.delete,
                            color: Colors.white70,
                          )),
                    ),
                  ]),
                );
              },
            ),
          ),
        ),
        TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
            onPressed: () {
              showUsage(context);
            },
            child: Row(children: const [
              Icon(
                size: 18,
                Icons.bar_chart,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text('使用详情', style: TextStyle(fontSize: 16, color: Colors.white)),
            ])),
        TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
            onPressed: () {
              showApikeyAuthForm(context);
            },
            child: Row(children: const [
              Icon(
                size: 18,
                Icons.key,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text('设置 APIKey', style: TextStyle(fontSize: 16, color: Colors.white)),
            ])),
        TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
            onPressed: () {
              widget.onConversationRemovePressed();
            },
            child: Row(children: const [
              Icon(
                size: 18,
                Icons.logout,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white)),
            ])),
      ]),
    );
  }
}




void showConversationEditForm(BuildContext context, String cid, String title, Function(String) callback) {
  final formKey = GlobalKey<FormState>();
  String _title = title;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('修改对话标题', style:  TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        contentPadding: const EdgeInsets.all(16.0),
        content: SizedBox(
          width: AppContext.isMobile() || AppContext.isWebMobile(context) ? 340 : 480,
          height: 140,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    maxLines: 1,
                    decoration: const InputDecoration(labelText: '', prefixIcon: Icon(Icons.key)),
                    onChanged: (value) => _title = value,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter text' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(padding: const EdgeInsets.all(15)),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
          TextButton(
             style: TextButton.styleFrom(padding: const EdgeInsets.all(15)),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                AppContext.dbManager.updateConversation(cid, _title);
                callback(_title);
                Navigator.of(context).pop();
              }
            },
            child: const Text('保存', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
