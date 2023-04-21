import 'package:gptchat/common/appcontext.dart';
import 'package:gptchat/common/models.dart';

typedef OnMessage = void Function(dynamic event);
typedef OnError = void Function(dynamic event);
typedef OnClose = void Function();

/// /////////////////////////////////////////////////////////////////////////////
/// OpenaiUtil Openai API 工具类
/// /////////////////////////////////////////////////////////////////////////////
class HistoryUtil {
  static final List<ChatCompletionMessage> _chatHistorys = [];

  static void clearChatHistorys() {
    _chatHistorys.clear();
  }

  /// reloadChatHistorys 从数据库获取最近的聊天记录
  static Future<void> reloadChatHistorys(String conversation, int maxRecords) async {
    var msgs = await AppContext.dbManager.getChatHistories(conversation, AppContext.chatEvent, maxRecords);
    _chatHistorys.clear();
    for (var hmsg in msgs) {
      _chatHistorys.add(ChatCompletionMessage(
        id: hmsg.id,
        role: hmsg.role,
        content: hmsg.content,
        conversation: hmsg.conversation,
      ));
    }
  }


  static void addChatMessage(ChatCompletionMessage msg) {
    _chatHistorys.add(msg);
    AppContext.dbManager.insertChatHistory(
      ChatHistory(
        id: msg.id!,
        event: AppContext.chatEvent,
        role: msg.role!,
        content: msg.content!,
        createdAt: DateTime.now(),
        conversation: msg.conversation!,
      ),
    );
  }

  static List<ChatCompletionMessage> _getLatestChatMessage(int n) {
    int startIndex = (_chatHistorys.length - n) < 0 ? 0 : (_chatHistorys.length - n);
    return _chatHistorys.sublist(startIndex);
  }

  static List<ChatCompletionMessage> getChatMessages() {
    return _chatHistorys.sublist(0);
  }

  /// get latest chat messages
  /// 用来发送聊天上下文
  static List<ChatCompletionMessage> getLatestChatMessages() {
    for (int n in [6, 4, 2]) {
      List<ChatCompletionMessage> msgs = _getLatestChatMessage(n);
      int lengthSum = 0;
      for (ChatCompletionMessage msg in msgs) {
        lengthSum += msg.content?.length ?? 0;
      }
      if (lengthSum < 2000) {
        return msgs;
      }
    }
    return [];
  }
}
