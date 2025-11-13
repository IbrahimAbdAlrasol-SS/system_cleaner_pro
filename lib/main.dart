import 'package:flutter/material.dart';
import 'package:system_cleaner_pro/ui/home_screen.dart';
import 'package:system_cleaner_pro/core/foreground_service.dart';

void main() {
  runApp(MyApp());
  // بدء الخدمة الخلفية تلقائياً
  ForegroundService().initialize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'System Cleaner Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}