import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:laotchat/common/models.dart';
import 'package:laotchat/common/openai.dart';

typedef OnMessage = void Function(dynamic data);
typedef OnClose = void Function(int code, String reason);
typedef OnError = void Function(dynamic error);

class WebSocketUtil {
  String? _url;
  WebSocket? _webSocket;
  OnMessage? onMessage;
  OnClose? onClose;
  OnError? onError;

  WebSocketUtil({required String url, this.onMessage, this.onClose, this.onError}) {
    _url = url;
    _initWebSocket();
  }

  Future<void> _initWebSocket() async {
    try {
      _webSocket = WebSocket(_url!);
      print('Connected to WebSocket server: $_url');
      _listen();
    } catch (e) {
      print('Error connecting to WebSocket server: $e');
      if (onError != null) {
        onError!(e);
      }
    }
  }

  void _listen() {
    _webSocket!.onMessage.listen(
      (event) {
        var data = event.data;
        if (onMessage != null) {
          onMessage!(data);
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error receiving data: $error');
        }
        if (onError != null) {
          onError!(error);
        }
      },
      onDone: () {
        if (kDebugMode) {
          print('WebSocket connection closed');
        }
        if (onClose != null) {
          onClose!(_webSocket!.readyState, "");
        }
      },
      cancelOnError: true,
    );
  }

  void send(dynamic data) {
    if (_webSocket!.readyState == WebSocket.OPEN) {
      if (kDebugMode) {
        print('Sending data: $data');
      }
      _webSocket!.sendString(data);
    } else {
      if (kDebugMode) {
        print('WebSocket is not connected');
      }
    }
  }

  void sendOpenaiChatMessage(OpenaiChatMessage msg) {
    var data = json.encode(msg);
    send(data);
  }

  Future<void> close([int code = 1000, String reason = '']) async {
    if (_webSocket!.readyState != WebSocket.CLOSED) {
      _webSocket!.close(1000, reason);
      if (kDebugMode) {
        print("close websocket connection with code: $code, reason: $reason");
      }
    }
  }
}
