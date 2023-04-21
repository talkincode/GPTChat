import 'package:dio/dio.dart';
import 'package:laotchat/common/appcontext.dart';
import 'package:laotchat/common/models.dart';

/// /////////////////////////////////////////////////////////////////////////////
/// SmsApi SMS API 工具类
/// /////////////////////////////////////////////////////////////////////////////
class SmsApi {

  /// 登录系统
  static Future<AuthResult> doLogin(String apikey) async {
    if (apikey == "") {
      return AuthResult(code: 1, msg: "APIKey 不能为空", data: null);
    }
    try {
      var url = '${AppContext.smsapi}/api/app/apikey/auth';
      var response = await Dio().post(url, data: {'apikey': apikey});
      if (response.statusCode == 200) {
        AuthResult result = AuthResult.fromJson(response.data);
        if (result.code > 0) {
          return result;
        }
        var userdata = result.data!;
        AppContext.saveUser(AccountData(
          apikey: apikey,
          username: userdata.username!,
          nickname: userdata.nickname!,
          mobile: userdata.mobile!,
          email: userdata.email!,
          token: userdata.token!,
          level: userdata.level!,
          expire: userdata.expire!,
        ));
        return result;
      } else {
        return AuthResult(code: 1, msg: "认证失败", data: null);
      }
    } catch (e) {
      return AuthResult(code: 1, msg: "认证异常 ${e.toString()}", data: null);
    }
  }


  /// Get the subscription usage details.
  /// 获取订阅使用详情
  static Future<SubsUsageResult> getSubsUsage() async {
    try {
      var url = '${AppContext.smsapi}/api/subscription/usage';
      // 发送请求并获取响应
      var opts = Options(headers: {"Authorization": "Bearer ${await AppContext.getUserToken()}"});
      var response = await Dio().get(url, options: opts);
      // 检查状态码是否为 200
      if (response.statusCode == 200) {
        SubsUsageResult result = SubsUsageResult.fromJson(response.data);
        return result;
      } else {
        return SubsUsageResult(code: 1, msg: "获取订阅使用详情失败", data: null);
      }
    } catch (e) {
      return SubsUsageResult(code: 1, msg: "获取订阅使用详情失败: ${e.toString()}", data: null);
    }
  }



  static Future<List<Map<String, dynamic>>> queryAispellList(String type, String tag) async {
    try {
      var url = '${AppContext.smsapi}/api/aispell/$type';
      // 发送请求并获取响应
      var opts = Options(headers: {"Authorization": "Bearer ${await AppContext.getUserToken()}"});
      var response = await Dio().get(url, options: opts, queryParameters: {'tag': tag});
      // 检查状态码是否为 200
      if (response.statusCode == 200) {
        // 解析响应数据为 Map 类型的 List
        List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> queryAispellTags(String type, int count) async {
    try {
      var url = '${AppContext.smsapi}/api/aispell/$type/tags/$count';
      // 发送请求并获取响应
      var opts = Options(headers: {"Authorization": "Bearer ${await AppContext.getUserToken()}"});
      var response = await Dio().get(url, options: opts);
      // 检查状态码是否为 200
      if (response.statusCode == 200 && response.data != null) {
        // 解析响应数据为 Map 类型的 List
        List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }









}

String getBillingDesc(String billType) {
  switch (billType) {
    case 'day':
      return '日付';
    case 'month':
      return '月付';
    case 'year':
      return '年付';
    case 'free':
      return '免费';
    case 'respack':
      return '资源包';
    default:
      return '未知';
  }
}
