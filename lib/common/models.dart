
import 'dart:convert';

/// /////////////////////////////////////////////////////////////////////////////
/// 登录结果
/// /////////////////////////////////////////////////////////////////////////////
class UserResult {
  String? username;
  String? rearname;
  String? nickname;
  String? mobile;
  String? email;
  String? token;
  String? level;
  int? expire;

  UserResult({
    required this.username,
    required this.token,
    required this.expire,
    this.rearname,
    this.nickname,
    this.mobile,
    this.level,
    this.email,
  });

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      username: json['username'] != null ? json['username'] as String : null,
      token: json['token'] != null ? json['token'] as String : null,
      expire: json['expire'] != null ? json['expire'] as int : null,
      rearname: json['rearname'] as String?,
      nickname: json['nickname'] as String?,
      mobile: json['mobile'] as String?,
      level: json['level'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'rearname': rearname,
      'nickname': nickname,
      'mobile': mobile,
      'email': email,
      'token': token,
      'level': level,
      'expire': expire,
    };
  }
}

/// /////////////////////////////////////////////////////////////////////////////
/// 认证接口返回结果
/// /////////////////////////////////////////////////////////////////////////////
class AuthResult {
  int code;
  String msg;
  UserResult? data;

  AuthResult({required this.code, required this.msg, required this.data});

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      code: json['code'] ?? 1,
      msg: json['msg'] ?? "",
      data: json['data'] != null ? UserResult.fromJson(json['data']) : null,
    );
  }
}

/// /////////////////////////////////////////////////////////////////////////////
/// RestResult SMS API 调用通用结果集
/// /////////////////////////////////////////////////////////////////////////////
class RestResult<T> {
  int code;
  String msg;
  T? data;

  RestResult({required this.code, required this.msg, this.data});

  factory RestResult.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return RestResult(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}


class SubsDetailResult {
  int code;
  String msg;
  SubscriptionDetail? data;

  SubsDetailResult({required this.code, required this.msg, this.data});

  factory SubsDetailResult.fromJson(Map<String, dynamic> json) {
    return SubsDetailResult(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: SubscriptionDetail.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class SubscriptionDetail {
  final String billType;
  final int maxRequests;
  final int maxTokens;
  final int maxImggens;
  final DateTime expireTime;
  final String status;

  SubscriptionDetail({
    required this.billType,
    required this.maxRequests,
    required this.maxTokens,
    required this.maxImggens,
    required this.expireTime,
    required this.status,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetail(
      billType: json['bill_type'],
      maxRequests: json['max_requests'],
      maxTokens: json['max_tokens'],
      maxImggens: json['max_imggens'],
      expireTime: DateTime.parse(json['expire_time']),
      status: json['status'],
    );
  }
}

class SubsUsageResult {
  int code;
  String msg;
  SubscriptionUsage? data;

  SubsUsageResult({required this.code, required this.msg, this.data});

  factory SubsUsageResult.fromJson(Map<String, dynamic> json) {
    return SubsUsageResult(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: SubscriptionUsage.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class SubscriptionUsage {
  final String customerId;
  final String subsId;
  final int useRequests;
  final int useTokens;
  final int useImggens;
  final int remainRequests;
  final int remainTokens;
  final int remainImggens;

  SubscriptionUsage({
    required this.customerId,
    required this.subsId,
    required this.useRequests,
    required this.useTokens,
    required this.useImggens,
    required this.remainRequests,
    required this.remainTokens,
    required this.remainImggens,
  });

  factory SubscriptionUsage.fromJson(Map<String, dynamic> json) {
    return SubscriptionUsage(
      customerId: json['customer_id'],
      subsId: json['subs_id'],
      useRequests: json['use_requests'],
      useTokens: json['use_tokens'],
      useImggens: json['use_imggens'],
      remainRequests: json['remain_requests'],
      remainTokens: json['remain_tokens'],
      remainImggens: json['remain_imggens'],
    );
  }
}






/// /////////////////////////////////////////////
/// history data models
/// /////////////////////////////////////////////

class ChatHistory {
  String id;
  String conversation;
  String event;
  String role;
  String content;
  int score;
  DateTime createdAt;

  ChatHistory({
    required this.id,
    required this.conversation,
    required this.event,
    required this.role,
    required this.content,
    this.score = 0,
    required this.createdAt,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'],
      conversation: json['conversation'],
      event: json['event'],
      role: json['role'],
      content: json['content'],
      score: json['score'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation': conversation,
      'event': event,
      'role': role,
      'content': content,
      'score': score,
      'created_at': createdAt.toIso8601String(),
    };
  }
}



class Conversation {
   String conversation;
   String name;
   String roleid;


  Conversation({required this.conversation, required this.name, required this.roleid});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversation: json['conversation'],
      name: json['name'],
      roleid: json['roleid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation': conversation,
      'name': name,
      'roleid': roleid,
    };
  }

}



/// /////////////////////////////////////////////////////////////////////////////
/// OpenaiChatMessage
/// /////////////////////////////////////////////////////////////////////////////
class OpenaiChatMessage {
  String? status;
  String? event;
  String? msgid;
  int? time;
  List<ChatCompletionMessage>? messages;
  ChatCompletionMessage? result;

  // 构造函数
  OpenaiChatMessage({this.status, this.event, this.msgid, this.time, this.messages, this.result});

// fromJson 工厂函数
  factory OpenaiChatMessage.fromJson(Map<String, dynamic> json) {
    return OpenaiChatMessage(
      status: json['status'],
      event: json['event'],
      msgid: json['msgid'],
      time: json['time'],
      messages: json['messages'] != null
          ? (json['messages'] as List).map((message) => ChatCompletionMessage.fromJson(message)).toList()
          : null,
      result: json['result'] != null ? ChatCompletionMessage.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'event': event,
        'msgid': msgid,
        'time': time,
        'messages': messages != null ? messages!.map((message) => message.toJson()).toList() : null,
        'result': result != null ? result!.toJson() : null,
      };
}

/// /////////////////////////////////////////////////////////////////////////////
/// ChatCompletionMessage
/// /////////////////////////////////////////////////////////////////////////////
class ChatCompletionMessage {
  String? id;
  String? conversation;
  String? role;
  String? content;

  //构造函数
  ChatCompletionMessage({this.id, this.conversation, this.role, this.content});

  factory ChatCompletionMessage.fromJson(Map<String, dynamic> json) {
    return ChatCompletionMessage(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };
}
