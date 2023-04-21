import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:laotchat/common/data_api_manager.dart';
import 'package:laotchat/common/platform_specific.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class AccountData {
  String? apikey;
  String? username;
  String? rearname;
  String? nickname;
  String? mobile;
  String? email;
  String? token;
  String? level;
  int? expire;

  AccountData({
    required this.apikey,
    required this.username,
    required this.token,
    required this.expire,
    this.rearname,
    this.nickname,
    this.mobile,
    this.level,
    this.email,
  });

  bool isLogin() {
    return token != null && token!.isNotEmpty;
  }
}

/// /////////////////////////////////////////////////////////////////////////////
/// 全局上下文
/// /////////////////////////////////////////////////////////////////////////////
class AppContext {
  // static String apiSite = "http://127.0.0.1:21979";

  static String apporg = "com.peaiot.laotchat";
  static String appid = "wxc70d5f7780ff4ec3";
  static String version = "V1.0.0";

  static String smsapi = "https://sms.pealabs.cn";
  // static String gptapi = "https://api.teamsgpt.cn";
  // static String smsapi = "https://teamsgpt.toughradius.net";
  // static String gptapi = "https://teamsgpt-api.toughradius.net";
  // static String smsapi = "http://127.0.0.1:8000";
  static String gptapi = "http://127.0.0.1:17980";
  static String cutimgargs = "?imageMogr2/thumbnail/200x/rradius/7/format/webp/interlace/1/quality/100";

  static final DataApiManager dbManager = DataApiManager(baseUrl: smsapi);

  static const String chatBot = "chatbot";
  static const String imgenBot = "imgenBot";

  static const String chatEvent = "EventChat";
  static const String writerEvent = "EventWriter";
  static const String copywriterEvent = "EventCopyWriter";
  static const String imgenEvent = "EventImgen";

  static const String noLogin = "NotLogin";
  static const String noSubs = "NotSubs";

  /// /////////////////////////////////////////////////////////////////////////////
  /// 登录成功后保存用户信息
  /// /////////////////////////////////////////////////////////////////////////////
  static saveUser(AccountData udata) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("laotchat_userdata_apikey", udata.apikey ?? "");
    prefs.setString("laotchat_userdata_username", udata.username ?? "");
    prefs.setString("laotchat_userdata_token", udata.token ?? "");
    prefs.setString("laotchat_userdata_level", udata.level ?? "user");
    prefs.setString("laotchat_userdata_nickname", udata.nickname ?? "");
    prefs.setString("laotchat_userdata_mobile", udata.mobile ?? "");
    prefs.setString("laotchat_userdata_email", udata.email ?? "");
    prefs.setString("laotchat_userdata_rearname", udata.rearname ?? "");
    prefs.setInt("laotchat_expire", udata.expire ?? 0);
  }

  /// /////////////////////////////////////////////////////////////////////////////
  /// 退出登录后清除用户信息
  /// /////////////////////////////////////////////////////////////////////////////
  static clearAccountata() async {
    var prefs = await SharedPreferences.getInstance();
    // prefs.setString("laotchat_userdata_username", "");
    prefs.setString("laotchat_userdata_token", "");
    prefs.setString("laotchat_userdata_nickname", "");
    prefs.setString("laotchat_userdata_level", "");
    prefs.setString("laotchat_userdata_mobile", "");
    prefs.setString("laotchat_userdata_email", "");
    prefs.setString("laotchat_userdata_rearname", "");
    prefs.setInt("laotchat_expire", 0);
  }

  // 获取用户token
  static Future<String> getUserToken() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("laotchat_userdata_token") ?? "";
    return token;
  }

  // 获取用户名
  static Future<String> getUsername() async {
    var prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("laotchat_userdata_username") ?? "";
    return username;
  }

  static Future<String> getApikey() async {
    var prefs = await SharedPreferences.getInstance();
    var username = prefs.getString("laotchat_userdata_username") ?? "";
    return username;
  }

  // 获取用户昵称
  static Future<String> getNickname() async {
    var prefs = await SharedPreferences.getInstance();
    var nickname = prefs.getString("laotchat_userdata_nickname") ?? "";
    return nickname;
  }

  static Future<String> getUserLevel() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("laotchat_userdata_level") ?? "user";
    return token;
  }

  // 获取用户信息
  static Future<AccountData> getAccountData() async {
    var prefs = await SharedPreferences.getInstance();
    var apikey = prefs.getString("laotchat_userdata_apikey") ?? "";
    var username = prefs.getString("laotchat_userdata_username") ?? "";
    var nickname = prefs.getString("laotchat_userdata_nickname") ?? "";
    var mobile = prefs.getString("laotchat_userdata_mobile") ?? "";
    var level = prefs.getString("laotchat_userdata_level") ?? "user";
    var email = prefs.getString("laotchat_userdata_email") ?? "";
    var rearname = prefs.getString("laotchat_userdata_rearname") ?? "";
    var token = prefs.getString("laotchat_userdata_token") ?? "";
    var expire = prefs.getInt("laotchat_expire") ?? 0;
    return AccountData(
      apikey: apikey,
      username: username,
      nickname: nickname,
      mobile: mobile,
      email: email,
      rearname: rearname,
      expire: expire,
      level: level,
      token: token,
    );
  }

  // 获取一个虚拟客户端ID
  static Future<String> getVClientId() async {
    var prefs = await SharedPreferences.getInstance();
    var vid = prefs.getString("laotchat_client_id") ?? "";
    if (vid == "") {
      vid = newUUID();
      prefs.setString("laotchat_client_id", vid);
    }
    return vid;
  }

  // newUUID 生成一个唯一ID
  static String newUUID() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  static String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  static bool isDesktop() {
    return PlatformUtils.isDesktop();
  }

  static bool isMobile() {
    return PlatformUtils.isMobile();
  }

  static bool isWebMobile(context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isWeb() {
    return PlatformUtils.isWeb();
  }

  static bool isBigWindows(context) {
    return !isMobile() && MediaQuery.of(context).size.width > 600;
  }

  static String md5Encrypt(String input) {
    List<int> bytes = utf8.encode(input); // 将输入字符串转换为字节
    Digest digest = md5.convert(bytes); // 计算 MD5 哈希值
    return digest.toString(); // 返回 MD5 哈希值的十六进制字符串表示
  }

  static String subString(String inputString, int len) {
    if (inputString.length <= len) {
      return inputString;
    } else {
      return "${inputString.substring(0, len)}...";
    }
  }

  // getDeviceUniqueId 获取系统唯一ID
  static Future<String?> getDeviceUniqueId() async {
    String clientid = await PlatformUtils.getDeviceUniqueId();
    if (clientid.isEmpty) {
      return await getVClientId();
    }
    return md5Encrypt(clientid);
  }

  static void showMessageBox(context, String msg, bool isErr) {
    if (isErr) {
      MotionToast.error(
        // title: const Text("错误提示", style: TextStyle(color: Colors.black54)),
        height: 90,
        position: MotionToastPosition.top,
        toastDuration: const Duration(seconds: 2),
        description: Text(msg, style: const TextStyle(color: Colors.red)),
      ).show(context);
      return;
    }

    MotionToast(
      // icon: Icons.notifications_active,
      position: MotionToastPosition.top,
      primaryColor: Colors.indigo.withOpacity(0.5),
      // title: const Text("消息提示", style: TextStyle(fontSize: 16, color: Colors.black54)),
      toastDuration: const Duration(seconds: 2),
      description: Text(msg, style: const TextStyle(color: Colors.black54)),
      width: 300,
      height: 90,
    ).show(context);
  }

  static void showMessage(context, String msg) {
    MotionToast(
      borderRadius: 7,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      position: MotionToastPosition.top,
      primaryColor: Colors.indigo.withOpacity(0.2),
      toastDuration: const Duration(seconds: 1),
      description: Text(msg, style: const TextStyle(color: Colors.black54)),
      width: 320,
      height: 50,
    ).show(context);
  }

  static Future<bool> confrimBox(BuildContext context, String msg) async {
    bool result = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('操作确认'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () async {
                result = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return result;
  }

  static Color getRandomMaterialColor({double opacity = 1.0}) {
    final random = Random();
    return Colors.primaries[random.nextInt(Colors.primaries.length)].withOpacity(opacity);
  }

  static Color getServicePlanMaterialColor({double opacity = 1.0, billtype = "free"}) {
    if (billtype == "free") {
      return Colors.green.withOpacity(opacity);
    }
    if (billtype == "day") {
      return Colors.cyan.withOpacity(opacity);
    }
    if (billtype == "month") {
      return Colors.blue.withOpacity(opacity);
    }
    if (billtype == "year") {
      return Colors.red.withOpacity(opacity);
    }
    if (billtype == "respack") {
      return Colors.orange.withOpacity(opacity);
    }
    return Colors.indigo.withOpacity(opacity);
  }
}
