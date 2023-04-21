import 'package:dio/dio.dart';
import 'package:laotchat/common/appcontext.dart';

typedef OnMessage = void Function(dynamic event);
typedef OnError = void Function(dynamic event);
typedef OnClose = void Function();

/// /////////////////////////////////////////////////////////////////////////////
/// OpenaiUtil Openai API 工具类
/// /////////////////////////////////////////////////////////////////////////////
class OpenaiUtil {
  static Future<String> translateText(String lang,String content) async {
    final response = await Dio().post(
      '${AppContext.gptapi}/translate',
      data: {
        'lang': lang,
        'content': content,
      },
      options: Options(headers: {"Authorization": "Bearer ${await AppContext.getUserToken()}"}),
    );

    if (response.data != null) {
      return response.data["msg"] as String;
    }
    return "翻译失败";
  }
}
