import 'package:farm_up/services/notification_service.dart';
import 'package:farm_up/services/inventory_service.dart';
import 'package:farm_up/services/water_management_service.dart';
import 'package:farm_up/services/disease_detection_service.dart';
import 'package:farm_up/services/government_schemes_service.dart';
import 'package:farm_up/models/inventory_item.dart';
import 'package:farm_up/models/water_schedule.dart';
import 'package:farm_up/models/disease_record.dart';
import 'package:farm_up/models/government_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final NotificationService _notificationService = NotificationService();
  final InventoryService _inventoryService = InventoryService();
  final WaterManagementService _waterService = WaterManagementService();
  final DiseaseDetectionService _diseaseService = DiseaseDetectionService();
  final GovernmentSchemesService _schemeService = GovernmentSchemesService();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    
    await _notificationService.initialize();
    _initialized = true;
    
    // Start checking for notifications periodically
    _startPeriodicChecks();
  }

  void _startPeriodicChecks() {
    // Check for notifications every hour
    Future.delayed(const Duration(hours: 1), () {
      _checkForNotifications();
      _startPeriodicChecks(); // Repeat
    });
  }

  Future<void> _checkForNotifications() async {
    // Check inventory alerts
    await _checkInventoryAlerts();
    
    // Check irrigation schedules
    await _checkIrrigationSchedules();
    
    // Check disease records
    await _checkDiseaseRecords();
    
    // Check government scheme deadlines
    await _checkSchemeDeadlines();
  }

  Future<void> _checkInventoryAlerts() async {
    try {
      final unresolvedAlerts = _inventoryService.getUnresolvedAlerts();
      
      for (var alert in unresolvedAlerts) {
        final item = _inventoryService.getInventoryItemById(alert.itemId);
        if (item != null) {
          await _notificationService.scheduleInventoryAlert(item, alert.alertType);
          
          // Mark alert as notified
          _inventoryService.markAlertAsNotified(alert.id!);
        }
      }
    } catch (e) {
      print('Error checking inventory alerts: $e');
    }
  }

  Future<void> _checkIrrigationSchedules() async {
    try {
      final upcomingSchedules = _waterService.getUpcomingIrrigationSchedules(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 7)),
      );
      
      for (var schedule in upcomingSchedules) {
        // Check if we've already sent a notification for this schedule
        final prefs = await SharedPreferences.getInstance();
        final notifiedKey = 'irrigation_notified_${schedule.id}';
        final alreadyNotified = prefs.getBool(notifiedKey) ?? false;
        
        if (!alreadyNotified && schedule.status != 'Completed') {
          await _notificationService.scheduleIrrigationReminder(schedule);
          
          // Mark as notified
          await prefs.setBool(notifiedKey, true);
        }
      }
    } catch (e) {
      print('Error checking irrigation schedules: $e');
    }
  }

  Future<void> _checkDiseaseRecords() async {
    try {
      final recentRecords = _diseaseService.getRecentDiseaseRecords(7); // Last 7 days
      
      for (var record in recentRecords) {
        // Check if we've already sent a notification for this record
        final prefs = await SharedPreferences.getInstance();
        final notifiedKey = 'disease_notified_${record.id}';
        final alreadyNotified = prefs.getBool(notifiedKey) ?? false;
        
        if (!alreadyNotified && record.status != 'Resolved') {
          await _notificationService.scheduleDiseaseAlert(record);
          
          // Mark as notified
          await prefs.setBool(notifiedKey, true);
        }
      }
    } catch (e) {
      print('Error checking disease records: $e');
    }
  }

  Future<void> _checkSchemeDeadlines() async {
    try {
      final activeSchemes = _schemeService.getActiveSchemes();
      
      for (var scheme in activeSchemes) {
        // Check if we've already sent a notification for this scheme
        final prefs = await SharedPreferences.getInstance();
        final notifiedKey = 'scheme_notified_${scheme.id}';
        final alreadyNotified = prefs.getBool(notifiedKey) ?? false;
        
        // Send notification if deadline is within 7 days and not already notified
        if (scheme.deadline != null && !alreadyNotified) {
          final daysUntilDeadline = scheme.deadline!.difference(DateTime.now()).inDays;
          if (daysUntilDeadline <= 7 && daysUntilDeadline >= 0) {
            await _notificationService.scheduleSchemeDeadline(scheme);
            
            // Mark as notified
            await prefs.setBool(notifiedKey, true);
          }
        }
      }
    } catch (e) {
      print('Error checking scheme deadlines: $e');
    }
  }

  // Public methods for services to trigger notifications

  Future<void> sendInventoryAlert(InventoryItem item, String alertType) async {
    await _notificationService.scheduleInventoryAlert(item, alertType);
  }

  Future<void> sendIrrigationReminder(WaterSchedule schedule) async {
    await _notificationService.scheduleIrrigationReminder(schedule);
  }

  Future<void> sendDiseaseAlert(DiseaseRecord record) async {
    await _notificationService.scheduleDiseaseAlert(record);
  }

  Future<void> sendSchemeDeadline(GovernmentScheme scheme) async {
    await _notificationService.scheduleSchemeDeadline(scheme);
  }

  Future<void> sendWeatherAlert(String alertType, String details) async {
    await _notificationService.scheduleWeatherAlert(alertType, details);
  }

  Future<void> sendMaintenanceReminder(String equipmentName, DateTime dueDate) async {
    await _notificationService.scheduleMaintenanceReminder(equipmentName, dueDate);
  }

  Future<void> sendHarvestReminder(String cropName, DateTime harvestDate) async {
    await _notificationService.scheduleHarvestReminder(cropName, harvestDate);
  }

  // Method to cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
  }

  // Method to cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }
}