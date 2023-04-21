import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:gptchat/common/appcontext.dart';

class MyEventSource {
  final Uri uri;
  late HttpRequest _request;
  final StreamController<String> _streamController;
  bool _isClosed = true;

  MyEventSource._(this.uri, this._streamController);

  static Future<MyEventSource> connect(Uri uri, String token, payload) async {
    final streamController = StreamController<String>();
    final eventSource = MyEventSource._(uri, streamController);
    await eventSource._connect(token, payload);
    return eventSource;
  }

  bool isClosed() {
    return _isClosed;
  }

  Future<void> _connect(String token, payload) async {
    try {
      final payloadJson = json.encode(payload);
      _request = HttpRequest();
      _request
        ..open("POST", uri.toString())
        ..setRequestHeader("Content-Type", "application/json;charset=UTF-8")
        ..setRequestHeader("Accept", "text/event-stream")
        ..setRequestHeader("Authorization", "Bearer $token")
        ..send(payloadJson);  // Keep this line here.


      _request.onReadyStateChange.listen((_) {
        if (_request.readyState == HttpRequest.DONE) {
          if (_request.status != 200) {
            String errstr = "";
            if (_request.status == 401) {
              errstr = "${AppContext.noLogin} 老铁，你还没有登录哦！";
            } else if (_request.status == 402) {
              errstr = "${AppContext.noSubs} 老铁，你的订阅额度不够， 请移步服务套餐领取免费套餐或购买套餐！";
            }else if (_request.status == 0) {
               _isClosed = true;
               return;
            }else{
              errstr = "${_request.status} 老铁，不好意思，出错了，歇会再来！";
            }
            _streamController.sink.addError(Exception(errstr));
            _isClosed = true;
          }
        }
      });

      String processedText = "";

      _request.onProgress.listen((ProgressEvent event) {
        String responseText = _request.responseText ?? "";

        // 仅处理新添加的文本
        String newText = responseText.substring(processedText.length);

        List<String> lines = LineSplitter.split(newText).toList();
        for (String line in lines) {
          if (line.isNotEmpty && line.startsWith('data:')) {
            if (_streamController.isClosed) return;
            _streamController.add(line.substring(5));
          }
        }

        // 更新已处理的消息
        processedText = responseText;
      }, onError: (error) {
        _streamController.sink.addError(error);
        _isClosed = true;
      });

      _isClosed = false;
    } catch (e) {
      _streamController.sink.addError(e);
      _isClosed = true;
    }
  }

  Stream<String> get stream => _streamController.stream;

  void close() {
    _request.abort();
    _streamController.close();
    _isClosed = true;
  }
}
