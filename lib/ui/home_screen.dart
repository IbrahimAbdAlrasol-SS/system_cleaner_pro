import 'package:flutter/material.dart';
import 'package:system_cleaner_pro/core/foreground_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ForegroundService _foregroundService = ForegroundService();
  bool _isOptimizing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('System Cleaner Pro'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[700]!, Colors.blue[500]!],
          ),
        ),
        child: Column(
          children: [
            // بطاقة حالة النظام
            _buildSystemStatusCard(),
            SizedBox(height: 20),
            // بطاقة التنظيف
            _buildCleanerCard(),
            SizedBox(height: 20),
            // إحصائيات مزيفة
            _buildStatsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'System Status: Optimal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 5),
            Text('Performance: 85%', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanerCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Quick Clean',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              'Clean temporary files and optimize memory',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performFakeClean,
              child: Text('START CLEANING'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.memory, color: Colors.blue),
                    SizedBox(height: 5),
                    Text('1.2 GB', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Cache', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.battery_std, color: Colors.green),
                    SizedBox(height: 5),
                    Text('78%', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Battery', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.storage, color: Colors.orange),
                    SizedBox(height: 5),
                    Text('64%', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Storage', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performFakeClean() {
    setState(() {
      _isOptimizing = true;
    });

    // محاكاة عملية تنظيف
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isOptimizing = false;
      });
      
      // إظهار نتيجة مزيفة
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Cleaning Complete'),
          content: Text('1.2 GB of temporary files cleaned successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}