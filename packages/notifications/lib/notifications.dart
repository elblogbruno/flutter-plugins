import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// Custom Exception for the plugin,
/// thrown whenever the plugin is used on platforms other than Android
class NotificationException implements Exception {
  String _cause;

  NotificationException(this._cause);

  @override
  String toString() {
    return _cause;
  }
}

class NotificationEvent {
  String packageMessage;
  String packageName;
  String appCategory;
  String packageTitle;
  DateTime timeStamp;

  NotificationEvent({this.packageName, this.packageMessage, this.timeStamp,this.appCategory,this.packageTitle});

  factory NotificationEvent.fromMap(Map<dynamic, dynamic> map) {
      print(map);
      DateTime time = DateTime.now();
      String name = map['packageName'];
      String message = map['packageMessage'];
      String category = map['appCategory'];
      String title  = map['packageTitle'];
      return NotificationEvent(packageName: name, packageMessage: message, timeStamp: time,appCategory: category,packageTitle: title);
  }

  @override
  String toString() {
    return "Notification Event \n Package Name: $packageName \n - Timestamp: $timeStamp \n - Package Message: $packageMessage \n - Package Category: $appCategory \n - Package Title: $packageTitle" ;
  }
}

NotificationEvent _notificationEvent(dynamic data) {
  return new NotificationEvent.fromMap(data);
}

class Notifications {
  static const EventChannel _notificationEventChannel =
      EventChannel('notifications.eventChannel');

  Stream<NotificationEvent> _notificationStream;

  Stream<NotificationEvent> get notificationStream {
    if (Platform.isAndroid) {
      if (_notificationStream == null) {
        _notificationStream = _notificationEventChannel
            .receiveBroadcastStream()
            .map((event) => _notificationEvent(event));
      }
      return _notificationStream;
    }
    throw NotificationException(
        'Notification API exclusively available on Android!');
  }
}
