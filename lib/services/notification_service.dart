import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:farm_up/models/inventory_item.dart';
import 'package:farm_up/models/water_schedule.dart';
import 'package:farm_up/models/disease_record.dart';
import 'package:farm_up/models/government_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'farm_up_notifications';
  static const String _channelName = 'FARM UP Notifications';
  static const String _channelDescription = 'Notifications for farming alerts and reminders';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    // Linux initialization settings
    const LinuxInitializationSettings linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );

    // Initialize settings for all platforms
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
      linux: linuxSettings,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap if needed
    print('Notification tapped: ${response.payload}');
  }

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? category,
  }) async {
    // Check if notifications are enabled
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    
    if (!notificationsEnabled) {
      return;
    }

    // Android notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      playSound: true,
      ticker: 'FARM UP Alert',
    );

    // iOS notification details
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Linux notification details
    const LinuxNotificationDetails linuxDetails = LinuxNotificationDetails();

    // Notification details for all platforms
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
      linux: linuxDetails,
    );

    // Show the notification
    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    String? category,
  }) async {
    // Check if notifications are enabled
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    
    if (!notificationsEnabled) {
      return;
    }

    // Convert to timezone-aware datetime
    final scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);

    // Android notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      playSound: true,
      ticker: 'FARM UP Reminder',
    );

    // iOS notification details
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Linux notification details
    const LinuxNotificationDetails linuxDetails = LinuxNotificationDetails();

    // Notification details for all platforms
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
      linux: linuxDetails,
    );

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTZ,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Specific notification methods for different farming scenarios

  Future<void> scheduleIrrigationReminder(WaterSchedule schedule) async {
    await scheduleNotification(
      id: schedule.id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Irrigation Reminder',
      body: 'Time to irrigate ${schedule.fieldName} field for ${schedule.durationMinutes} minutes',
      scheduledTime: schedule.scheduledDate,
      payload: 'irrigation_reminder_${schedule.id}',
      category: 'irrigation',
    );
  }

  Future<void> scheduleInventoryAlert(InventoryItem item, String alertType) async {
    final now = DateTime.now();
    final alertId = (item.id ?? 0) + now.millisecondsSinceEpoch ~/ 1000;
    
    String title = 'Inventory Alert';
    String body = '';
    
    switch (alertType) {
      case 'Expiry':
        title = 'Item Expiring Soon';
        body = '${item.itemName} expires on ${item.expiryDate.toString().split(' ').first}';
        break;
      case 'LowStock':
        title = 'Low Stock Alert';
        body = 'Low stock for ${item.itemName}. Only ${item.quantity} ${item.unit} remaining';
        break;
      case 'CriticalItem':
        title = 'Critical Item Needed';
        body = 'Important item needed: ${item.itemName}';
        break;
      default:
        body = 'Alert for ${item.itemName}';
    }

    await showImmediateNotification(
      id: alertId,
      title: title,
      body: body,
      payload: 'inventory_alert_${item.id}',
      category: 'inventory',
    );
  }

  Future<void> scheduleDiseaseAlert(DiseaseRecord record) async {
    await showImmediateNotification(
      id: record.id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Disease Alert',
      body: 'Detected ${record.diseaseName} on ${record.cropName}. Take immediate action.',
      payload: 'disease_alert_${record.id}',
      category: 'disease',
    );
  }

  Future<void> scheduleSchemeDeadline(GovernmentScheme scheme) async {
    if (scheme.deadline != null) {
      await scheduleNotification(
        id: scheme.id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Scheme Deadline Reminder',
        body: '${scheme.schemeName} application deadline is approaching',
        scheduledTime: scheme.deadline!,
        payload: 'scheme_deadline_${scheme.id}',
        category: 'scheme',
      );
    }
  }

  Future<void> scheduleWeatherAlert(String alertType, String details) async {
    final now = DateTime.now();
    final alertId = now.millisecondsSinceEpoch ~/ 1000;
    
    String title = 'Weather Alert';
    
    switch (alertType) {
      case 'rain':
        title = 'Rain Expected';
        break;
      case 'frost':
        title = 'Frost Warning';
        break;
      case 'hail':
        title = 'Hail Storm Warning';
        break;
      case 'drought':
        title = 'Drought Conditions';
        break;
    }

    await showImmediateNotification(
      id: alertId,
      title: title,
      body: details,
      payload: 'weather_alert_$alertType',
      category: 'weather',
    );
  }

  Future<void> scheduleMaintenanceReminder(String equipmentName, DateTime dueDate) async {
    final now = DateTime.now();
    final reminderId = now.millisecondsSinceEpoch ~/ 1000;
    
    await scheduleNotification(
      id: reminderId,
      title: 'Equipment Maintenance',
      body: '$equipmentName requires maintenance by ${dueDate.toString().split(' ').first}',
      scheduledTime: dueDate,
      payload: 'maintenance_reminder_$equipmentName',
      category: 'maintenance',
    );
  }

  Future<void> scheduleHarvestReminder(String cropName, DateTime harvestDate) async {
    final now = DateTime.now();
    final reminderId = now.millisecondsSinceEpoch ~/ 1000;
    
    await scheduleNotification(
      id: reminderId,
      title: 'Harvest Time',
      body: '$cropName is ready for harvest on ${harvestDate.toString().split(' ').first}',
      scheduledTime: harvestDate,
      payload: 'harvest_reminder_$cropName',
      category: 'harvest',
    );
  }

  // Method to check and send pending notifications
  Future<void> checkAndSendPendingNotifications() async {
    // This would typically check various services for pending alerts
    // For now, we'll just log the action
    print('Checking for pending notifications...');
  }
}