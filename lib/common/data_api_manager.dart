import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/models.dart';

class DataApiManager {
  static final DataApiManager _instance = DataApiManager._internal();
  final Dio _dio = Dio();
  late String _baseUrl;

  factory DataApiManager({String? baseUrl}) {
    _instance._baseUrl = baseUrl ?? 'https://laotsms.toughstruct.net';
    return _instance;
  }

  DataApiManager._internal();

  static Future<String> getUserToken() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("gptchat_userdata_token") ?? "";
    return token;
  }

  Future<void> insertChatHistory(ChatHistory chatHistory) async {
    await _dio.post(
      '$_baseUrl/api/history/chat/add',
      data: FormData.fromMap(chatHistory.toJson()),
      options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
    );
  }

  Future<List<ChatHistory>> getChatHistories(String conversation, String event, int maxRecords) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/history/chat/query',
        queryParameters: {
          'conversation': conversation,
          'event': event,
          'count': maxRecords,
        },
        options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
      );

      final List<dynamic> data = response.data;
      return data
          .map((json) => ChatHistory.fromJson(json))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<ChatHistory?> getLatestChatHistory(String event) async {
    final response = await _dio.get(
      '$_baseUrl/api/history/chat/latest',
      queryParameters: {
        'event': event,
      },
      options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
    );

    if (response.data != null) {
      return ChatHistory.fromJson(response.data);
    }
    return null;
  }


  Future<dynamic> getConversationRole(String roleid) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/conversation/role',
        queryParameters: {
          'roleid': roleid,
        },
        options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
      );
      if (response.statusCode != 200 || response.data == null) {
        return {
          "id": "default",
          "name": "与 ChatGPT 对话",
        };
      }
      return response.data;
    } catch (e) {
      return {
        "id": "default",
        "name": "与 ChatGPT 对话",
      };
    }
  }

  Future<List<Conversation>> listConversations() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/api/conversation/list',
        options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
      );

      if (response.statusCode != 200 || response.data == null) {
        return [];
      }
      final List<dynamic> data = response.data;
      return data.map((json) => Conversation.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> createConversation(Conversation conversation) async {
    final response = await _dio.post(
      '$_baseUrl/api/conversation/create',
      data: FormData.fromMap(conversation.toJson()),
      options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
    );
    return response.statusCode ?? 0;
  }

  Future<int> updateConversation(String cid, String title) async {
    final response = await _dio.post(
      '$_baseUrl/api/conversation/update',
      data: FormData.fromMap({
        "conversation": cid,
        "name": title,
      }),
      options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
    );
    return response.statusCode ?? 0;
  }

  Future<int> deleteConversation(String conversation) async {
    final response = await _dio.delete(
      '$_baseUrl/api/conversation/delete',
      queryParameters: {
        'conversation': conversation,
      },
      options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
    );
    return response.statusCode ?? 0;
  }

  Future<int> updateChatHistory(ChatHistory chatHistory) async {
    final response = await _dio.put(
      '$_baseUrl/api/history/chat/update',
      data: chatHistory.toJson(),
      options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
    );
    return response.statusCode ?? 0;
  }


  Future<int> deleteChatHistory(String id) async {
    final response = await _dio.delete(
      '$_baseUrl/api/history/chat/delete',
      queryParameters: {
        'id': id,
      },
      options: Options(headers: {"Authorization": "Bearer ${await getUserToken()}"}),
    );

    return response.statusCode ?? 0;
  }



}
