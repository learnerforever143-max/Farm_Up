import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farm_up/database/database_helper.dart';
import 'package:farm_up/models/user.dart';
import 'package:farm_up/models/soil_data.dart';
import 'package:farm_up/models/budget_item.dart';
import 'package:farm_up/models/disease_record.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isSyncing = false;
  Timer? _syncTimer;

  // Check if device is online
  Future<bool> _isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Initialize sync service
  void initializeSync() {
    // Set up periodic sync every 5 minutes
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      syncAllData();
    });
  }

  // Sync all data
  Future<void> syncAllData() async {
    if (_isSyncing) return;
    
    _isSyncing = true;
    
    try {
      final isOnline = await _isOnline();
      if (!isOnline) {
        print('Device is offline. Skipping sync.');
        return;
      }
      
      print('Starting data synchronization...');
      
      // Sync users
      await _syncUsers();
      
      // Sync soil data
      await _syncSoilData();
      
      // Sync budget items
      await _syncBudgetItems();
      
      // Sync disease records
      await _syncDiseaseRecords();
      
      // Update last sync time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_sync_time', DateTime.now().toIso8601String());
      
      print('Data synchronization completed successfully.');
    } catch (e) {
      print('Error during synchronization: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // Sync users
  Future<void> _syncUsers() async {
    try {
      // Get local users
      final localUsers = await _dbHelper.getUsers();
      
      // In a real implementation, this would sync with a cloud API
      // For now, we'll just log the action
      print('Syncing ${localUsers.length} users with cloud');
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mark users as synced
      final prefs = await SharedPreferences.getInstance();
      for (var user in localUsers) {
        await prefs.setBool('user_${user.id}_synced', true);
      }
    } catch (e) {
      print('Error syncing users: $e');
    }
  }

  // Sync soil data
  Future<void> _syncSoilData() async {
    try {
      // In a real implementation, this would get all unsynced soil data
      // and send to cloud API, then mark as synced
      
      print('Syncing soil data with cloud');
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      print('Error syncing soil data: $e');
    }
  }

  // Sync budget items
  Future<void> _syncBudgetItems() async {
    try {
      // In a real implementation, this would get all unsynced budget items
      // and send to cloud API, then mark as synced
      
      print('Syncing budget items with cloud');
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      print('Error syncing budget items: $e');
    }
  }

  // Sync disease records
  Future<void> _syncDiseaseRecords() async {
    try {
      // In a real implementation, this would get all unsynced disease records
      // and send to cloud API, then mark as synced
      
      print('Syncing disease records with cloud');
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      print('Error syncing disease records: $e');
    }
  }

  // Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString('last_sync_time');
    if (lastSyncString != null) {
      return DateTime.parse(lastSyncString);
    }
    return null;
  }

  // Check if data is synced
  Future<bool> isDataSynced(String dataType, int id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${dataType}_${id}_synced') ?? false;
  }

  // Mark data as synced
  Future<void> markDataAsSynced(String dataType, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${dataType}_${id}_synced', true);
  }

  // Cancel sync timer
  void cancelSync() {
    _syncTimer?.cancel();
  }
}