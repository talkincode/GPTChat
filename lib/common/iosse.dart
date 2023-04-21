import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:laotchat/common/appcontext.dart';

class MyEventSource {
  final Uri uri;
  final HttpClient _client;
  final StreamController<String> _streamController;
  bool _isClosed = true;

  MyEventSource._(this.uri, this._client, this._streamController);

  static Future<MyEventSource> connect(Uri uri, token, payload) async {
    var client = HttpClient();
    var streamController = StreamController<String>();
    var eventSource = MyEventSource._(uri, client, streamController);
    await eventSource._connect(token, payload);
    return eventSource;
  }

  bool isClosed() {
    return _isClosed;
  }

  Future<void> _connect(token, payload) async {
    try {
      HttpClientRequest request = await _client.postUrl(uri);
      request.headers.add(HttpHeaders.acceptHeader, 'text/event-stream');
      request.headers.add(HttpHeaders.contentTypeHeader, "application/json;charset=UTF-8");
      request.headers.add(HttpHeaders.authorizationHeader, "Bearer $token");
      final payloadJson = json.encode(payload);
      request.write(payloadJson);
      HttpClientResponse response = await request.close();
      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          throw Exception("${AppContext.noLogin} 老铁，你还没有登录哦！");
        }
        if (response.statusCode == 402) {
          throw Exception("${AppContext.noSubs} 老铁，你的订阅额度不够， 请移步服务套餐领取免费套餐或购买套餐！");
        }
        throw Exception("${response.statusCode} 老铁，不好意思，出错了，歇会再来！");
      }
      response.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
        if (line.isNotEmpty && line.startsWith('data:')) {
          if (_streamController.isClosed) return;
          _streamController.add(line.substring(5));
        }
      }, onError: _onError, onDone: _onDone);
      _isClosed = false;
      print("iosse connected");
    } catch (e) {
      _onError(e);
    }
  }

  void _onError(dynamic error) {
    print('iosse error: $error');
    _isClosed = true;
    _streamController.sink.addError(error);
    // _reconnect();
  }

  void _onDone() {
    _isClosed = true;
    print('iosse connection closed');
    // _reconnect();
  }

  Stream<String> get stream => _streamController.stream;

  // 关闭方法
  void close() {
    _client.close(force: true);
    _streamController.close();
    _isClosed = true;
  }
}
