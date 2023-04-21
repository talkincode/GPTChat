import 'package:event_bus/event_bus.dart';
import 'dart:async';


EventBus eventBus = EventBus();

class UpdateDownloadEvent {
  String state;
  UpdateDownloadEvent(this.state);
}

class UpdateAppEvent {
  AppVersion version;
  UpdateAppEvent(this.version);
}

class NoUpdateAppEvent {
  AppVersion version;
  NoUpdateAppEvent(this.version);
}

class AppVersion {
  String platform;
  String version;
  String url;
  String appname;
  String remark;

  AppVersion({required this.platform, required this.version, required this.url, required this.appname, required this.remark});

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      platform: json['platform'],
      version: json['version'],
      url: json['url'],
      appname: json['appname'],
      remark: json['remark'],
    );
  }
}

class Common {
  static int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
