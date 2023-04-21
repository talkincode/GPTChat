
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

/// /////////////////////////////////////////////////////////////////////////////
/// 套餐服务计划
/// /////////////////////////////////////////////////////////////////////////////
class ServicePlan {
  String id;
  String name; // 名称
  int price; // 单位：分
  String billType; // day:日付  month:月付  year：年付
  int maxTokens; // 最大令牌数
  int maxRequests; // 最大请求次数
  int maxImggens; // 最大图像生成次数
  String? remark; // 备注
  DateTime createdAt; // 创建时间
  DateTime updatedAt; // 更新时间

  ServicePlan({
    required this.id,
    required this.name,
    required this.price,
    required this.billType,
    required this.maxTokens,
    required this.maxRequests,
    required this.maxImggens,
    this.remark,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServicePlan.fromJson(Map<String, dynamic> json) {
    return ServicePlan(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      billType: json['bill_type'],
      maxTokens: json['max_tokens'],
      maxRequests: json['max_requests'],
      maxImggens: json['max_imggens'],
      remark: json['remark'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'bill_type': billType,
      'max_tokens': maxTokens,
      'max_requests': maxRequests,
      'max_imggens': maxImggens,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
    if (remark != null) {
      data['remark'] = remark;
    }
    return data;
  }
}

class ServicePlanResult {
  int code;
  String msg;
  List<ServicePlan> data;

  ServicePlanResult({required this.code, required this.msg, required this.data});

  factory ServicePlanResult.fromJson(Map<String, dynamic> json) {
    return ServicePlanResult(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: (json['data'] as List<dynamic>)
          .map((dynamic item) => ServicePlan.fromJson(item as Map<String, dynamic>))
          .toList(),
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

class NativeOrderCreateResponse {
  final String qrcodeFile;
  final String orderId;
  final String name;
  final int amount;
  final DateTime expireTime;

  NativeOrderCreateResponse({
    required this.qrcodeFile,
    required this.orderId,
    required this.name,
    required this.amount,
    required this.expireTime,
  });

  factory NativeOrderCreateResponse.fromJson(Map<String, dynamic> json) {
    return NativeOrderCreateResponse(
      qrcodeFile: json['qrcode_file'] ?? '',
      orderId: json['order_id'] ?? '',
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
      expireTime: json['expire_time'] != null ? DateTime.parse(json['expire_time']) : DateTime.now(),
    );
  }
}

class NativeOrderResult {
  int code;
  String msg;
  NativeOrderCreateResponse? data;

  NativeOrderResult({required this.code, required this.msg, this.data});

  factory NativeOrderResult.fromJson(Map<String, dynamic> json) {
    return NativeOrderResult(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: NativeOrderCreateResponse.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}



class AppOrderCreateResponse {
  final String appid;
  final String mchid;
  final String prepayid;
  final String orderId;
  final String name;
  final String nonce;
  final int timestamp;
  final String sign;

  AppOrderCreateResponse({
    required this.appid,
    required this.mchid,
    required this.prepayid,
    required this.orderId,
    required this.name,
    required this.nonce,
    required this.timestamp,
    required this.sign,
  });

  factory AppOrderCreateResponse.fromJson(Map<String, dynamic> json) {
    return AppOrderCreateResponse(
      appid: json['appid'] ?? '',
      mchid: json['mchid'] ?? '',
      prepayid: json['prepay_id'] ?? '',
      orderId: json['order_id'] ?? '',
      name: json['name'] ?? '',
      nonce: json['nonce'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      sign: json['sign'] ?? '',
    );
  }
}

class AppOrderResult {
  int code;
  String msg;
  AppOrderCreateResponse? data;

  AppOrderResult({required this.code, required this.msg, this.data});

  factory AppOrderResult.fromJson(Map<String, dynamic> json) {
    return AppOrderResult(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: AppOrderCreateResponse.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}


class AiRoleSpell {
  String id;
  String name;
  String content;
  int score;
  int likes;
  int dislike;
  List<String> tags;
  DateTime createdAt;
  DateTime updatedAt;

  AiRoleSpell({
    required this.id,
    required this.name,
    required this.content,
    required this.score,
    required this.likes,
    required this.dislike,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiRoleSpell.fromJson(Map<String, dynamic> json) {
    return AiRoleSpell(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      score: json['score'],
      likes: json['like'],
      dislike: json['dislike'],
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'score': score,
      'like': likes,
      'dislike': dislike,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String toEncodedJson() => json.encode(toJson());
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

class ImageHistory {
  String id;
  String prompt;
  String url;
  String size;
  DateTime createdAt;

  ImageHistory({
    required this.id,
    required this.prompt,
    required this.url,
    required this.size,
    required this.createdAt,
  });

  factory ImageHistory.fromJson(Map<String, dynamic> json) {
    return ImageHistory(
      id: json['id'],
      prompt: json['prompt'],
      url: json['url'],
      size: json['size'] ?? "512x512",
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'url': url,
      'size': size,
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

class ImageCreateRequest {
  String src;
  bool opt;
  String prompt;
  String size;
  int num;
  String format;

  ImageCreateRequest(
      {required this.src,
      required this.opt,
      required this.prompt,
      required this.size,
      required this.num,
      required this.format});

  Map<String, dynamic> toJson() => {
        'src': src,
        'opt': opt,
        'prompt': prompt,
        'size': size,
        'num': num,
        'format': format,
      };
}

class ImageCreateResult {
  int code;
  String msg;
  List<String>? data;

  ImageCreateResult({required this.code, required this.msg, this.data});

  factory ImageCreateResult.fromJson(Map<String, dynamic> json) {
    return ImageCreateResult(
      code: json['code'] as int,
      msg: json['msg'] as String,
      data: json['data'] == null ? null : (json['data'] as List<dynamic>).map((e) => e['url'] as String).toList(),
    );
  }
}
