import 'dart:convert';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class ZWAppAggregatorService {
  static final ZWAppAggregatorService _instance = ZWAppAggregatorService._internal();
  factory ZWAppAggregatorService() => _instance;
  ZWAppAggregatorService._internal();

  final Map<String, dynamic> _appCache = {};
  final List<String> _preferredApps = [];

  Future<List<Application>> getInstalledApps() async {
    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: false,
        sort: true,
      );
      
      // Filter out ZW app itself and system apps
      apps = apps.where((app) => 
        app.packageName != 'com.example.socialai' && 
        !app.packageName.startsWith('com.android') &&
        !app.packageName.startsWith('com.google.android')
      ).toList();
      
      return apps;
    } catch (e) {
      print('Error getting installed apps: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getAppDetails(String packageName) async {
    if (_appCache.containsKey(packageName)) {
      return _appCache[packageName]!;
    }

    try {
      Application? app = await DeviceApps.getApp(packageName);
      if (app != null) {
        Map<String, dynamic> details = {
          'name': app.appName,
          'packageName': app.packageName,
          'version': app.versionName ?? 'Unknown',
          'category': _categorizeApp(app.appName),
          'lastUpdated': app.firstInstallTime?.millisecondsSinceEpoch ?? 0,
          'size': app.apkFilePath?.length ?? 0,
        };
        
        _appCache[packageName] = details;
        return details;
      }
    } catch (e) {
      print('Error getting app details: $e');
    }
    
    return {};
  }

  Future<List<String>> getUserPreferredApps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('zw_preferred_apps') ?? [];
  }

  Future<void> setUserPreferredApps(List<String> packageNames) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('zw_preferred_apps', packageNames);
    _preferredApps.clear();
    _preferredApps.addAll(packageNames);
  }

  Future<List<Map<String, dynamic>>> getAggregatedUpdates() async {
    List<String> preferredApps = await getUserPreferredApps();
    List<Map<String, dynamic>> updates = [];
    
    for (String packageName in preferredApps) {
      List<Map<String, dynamic>> appUpdates = await _getAppUpdates(packageName);
      updates.addAll(appUpdates);
    }
    
    // Sort by timestamp (newest first)
    updates.sort((a, b) => (b['timestamp'] ?? 0).compareTo(a['timestamp'] ?? 0));
    
    return updates;
  }

  Future<String> generateAISummary() async {
    List<Map<String, dynamic>> updates = await getAggregatedUpdates();
    
    if (updates.isEmpty) {
      return "No updates available. Please select some apps to monitor.";
    }
    
    // Mock AI summary generation
    Map<String, int> appCounts = {};
    for (var update in updates) {
      String appName = update['appName'] ?? 'Unknown';
      appCounts[appName] = (appCounts[appName] ?? 0) + 1;
    }
    
    String summary = "📱 AI Summary of your app updates:\n\n";
    summary += "• Total updates: ${updates.length}\n";
    summary += "• Apps with updates: ${appCounts.length}\n";
    summary += "• Most active app: ${appCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key}\n\n";
    summary += "🎯 Key insights:\n";
    summary += "• You have ${updates.where((u) => u['priority'] == 'high').length} high-priority updates\n";
    summary += "• ${updates.where((u) => u['type'] == 'notification').length} notifications pending\n";
    summary += "• Consider reviewing social media updates first\n\n";
    summary += "💡 AI Recommendations:\n";
    summary += "• Set up notification filters for better organization\n";
    summary += "• Enable auto-summarization for long content\n";
    summary += "• Schedule regular review times for optimal productivity";
    
    return summary;
  }

  Future<bool> hasAccessibilityPermission() async {
    return await Permission.accessibilityEvents.isGranted;
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.accessibilityEvents,
      Permission.notification,
      Permission.storage,
    ].request();
    
    return statuses.values.every((status) => status.isGranted);
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> info = {};
    
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        info = {
          'platform': 'Android',
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'brand': androidInfo.brand,
          'model': androidInfo.model,
        };
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
    
    return info;
  }

  String _categorizeApp(String appName) {
    appName = appName.toLowerCase();
    
    if (appName.contains('whatsapp') || appName.contains('telegram') || appName.contains('signal')) {
      return 'messaging';
    } else if (appName.contains('instagram') || appName.contains('facebook') || appName.contains('twitter')) {
      return 'social';
    } else if (appName.contains('youtube') || appName.contains('netflix') || appName.contains('spotify')) {
      return 'entertainment';
    } else if (appName.contains('gmail') || appName.contains('outlook') || appName.contains('email')) {
      return 'email';
    } else if (appName.contains('chrome') || appName.contains('firefox') || appName.contains('safari')) {
      return 'browser';
    } else if (appName.contains('camera') || appName.contains('gallery') || appName.contains('photo')) {
      return 'media';
    } else {
      return 'other';
    }
  }

  Future<List<Map<String, dynamic>>> _getAppUpdates(String packageName) async {
    // Mock implementation - in real app, this would parse accessibility data
    List<Map<String, dynamic>> updates = [];
    
    Map<String, dynamic> appDetails = await getAppDetails(packageName);
    String appName = appDetails['name'] ?? 'Unknown App';
    
    // Generate mock updates
    List<String> mockContents = [
      'New message received from contact',
      'Post liked by 5 people',
      'New video uploaded',
      'System update available',
      'Battery optimization recommended',
      'New email in inbox',
      'Calendar reminder: Meeting in 30 minutes',
      'Weather alert: Rain expected',
      'App update available',
      'Storage space running low',
    ];
    
    List<String> types = ['notification', 'update', 'message', 'alert'];
    List<String> priorities = ['low', 'medium', 'high'];
    
    for (int i = 0; i < 3; i++) {
      updates.add({
        'id': '${packageName}_${DateTime.now().millisecondsSinceEpoch}_$i',
        'appName': appName,
        'packageName': packageName,
        'title': 'Update from $appName',
        'content': mockContents[i % mockContents.length],
        'timestamp': DateTime.now().subtract(Duration(hours: i)).millisecondsSinceEpoch,
        'type': types[i % types.length],
        'priority': priorities[i % priorities.length],
        'read': false,
      });
    }
    
    return updates;
  }
} 