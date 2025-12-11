import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farm_up/database/database_helper.dart';
import 'package:farm_up/services/sync_service.dart';
import 'package:farm_up/models/user.dart';
import 'package:farm_up/models/soil_data.dart';
import 'package:farm_up/models/crop_recommendation.dart';
import 'package:farm_up/models/budget_item.dart';
import 'package:farm_up/models/weather_data.dart';
import 'package:farm_up/models/water_schedule.dart';
import 'package:farm_up/models/disease_record.dart';

class OfflineManager {
  static final OfflineManager _instance = OfflineManager._internal();
  factory OfflineManager() => _instance;
  OfflineManager._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final SyncService _syncService = SyncService();
  bool _isOfflineMode = false;

  // Initialize offline manager
  Future<void> initialize() async {
    // Check if offline mode is enabled in settings
    final prefs = await SharedPreferences.getInstance();
    _isOfflineMode = prefs.getBool('offline_mode_enabled') ?? false;
    
    // Initialize sync service
    _syncService.initializeSync();
  }

  // Check if device is online
  Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Toggle offline mode
  Future<void> toggleOfflineMode(bool enable) async {
    _isOfflineMode = enable;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offline_mode_enabled', enable);
  }

  // Check if offline mode is enabled
  bool isOfflineModeEnabled() {
    return _isOfflineMode;
  }

  // Save user data locally
  Future<int> saveUserLocally(User user) async {
    try {
      final id = await _dbHelper.insertUser(user);
      print('User saved locally with ID: $id');
      return id;
    } catch (e) {
      print('Error saving user locally: $e');
      rethrow;
    }
  }

  // Get user data locally
  Future<List<User>> getUsersLocally() async {
    try {
      final users = await _dbHelper.getUsers();
      print('Retrieved ${users.length} users from local database');
      return users;
    } catch (e) {
      print('Error retrieving users locally: $e');
      rethrow;
    }
  }

  // Save soil data locally
  Future<int> saveSoilDataLocally(SoilData soilData) async {
    try {
      final id = await _dbHelper.insertSoilData(soilData);
      print('Soil data saved locally with ID: $id');
      return id;
    } catch (e) {
      print('Error saving soil data locally: $e');
      rethrow;
    }
  }

  // Get soil data locally
  Future<List<SoilData>> getSoilDataByUserIdLocally(int userId) async {
    try {
      final soilData = await _dbHelper.getSoilDataByUserId(userId);
      print('Retrieved ${soilData.length} soil data entries from local database');
      return soilData;
    } catch (e) {
      print('Error retrieving soil data locally: $e');
      rethrow;
    }
  }

  // Save budget item locally
  Future<int> saveBudgetItemLocally(BudgetItem budgetItem) async {
    try {
      final id = await _dbHelper.insertBudgetItem(budgetItem);
      print('Budget item saved locally with ID: $id');
      return id;
    } catch (e) {
      print('Error saving budget item locally: $e');
      rethrow;
    }
  }

  // Get budget items locally
  Future<List<BudgetItem>> getBudgetItemsByUserIdLocally(int userId) async {
    try {
      final budgetItems = await _dbHelper.getBudgetItemsByUserId(userId);
      print('Retrieved ${budgetItems.length} budget items from local database');
      return budgetItems;
    } catch (e) {
      print('Error retrieving budget items locally: $e');
      rethrow;
    }
  }

  // Save disease record locally
  Future<int> saveDiseaseRecordLocally(DiseaseRecord record) async {
    try {
      final id = await _dbHelper.insertDiseaseRecord(record);
      print('Disease record saved locally with ID: $id');
      return id;
    } catch (e) {
      print('Error saving disease record locally: $e');
      rethrow;
    }
  }

  // Get disease records locally
  Future<List<DiseaseRecord>> getDiseaseRecordsByUserIdLocally(int userId) async {
    try {
      final records = await _dbHelper.getDiseaseRecordsByUserId(userId);
      print('Retrieved ${records.length} disease records from local database');
      return records;
    } catch (e) {
      print('Error retrieving disease records locally: $e');
      rethrow;
    }
  }

  // Attempt to sync data when coming online
  Future<void> attemptSyncWhenOnline() async {
    final isOnline = await isOnline();
    if (isOnline) {
      print('Device is online. Attempting to sync data...');
      await _syncService.syncAllData();
    } else {
      print('Device is offline. Cannot sync data at this time.');
    }
  }

  // Get sync status
  Future<Map<String, dynamic>> getSyncStatus() async {
    final isOnline = await isOnline();
    final lastSyncTime = await _syncService.getLastSyncTime();
    
    return {
      'isOnline': isOnline,
      'isOfflineMode': _isOfflineMode,
      'lastSyncTime': lastSyncTime,
    };
  }

  // Cache data for offline use
  Future<void> cacheDataForOfflineUse() async {
    // In a real implementation, this would cache frequently accessed data
    // For now, we'll just log the action
    print('Caching data for offline use');
  }
}