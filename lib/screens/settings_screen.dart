import 'package:flutter/material.dart';
import 'package:farm_up/services/offline_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  
  const SettingsScreen({super.key, this.onThemeChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final OfflineManager _offlineManager = OfflineManager();
  bool _isOfflineMode = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'en';
  DateTime? _lastSyncTime;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _isOfflineMode = prefs.getBool('offline_mode_enabled') ?? false;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _selectedLanguage = prefs.getString('selected_language') ?? 'en';
    });
    
    // Get last sync time
    final syncStatus = await _offlineManager.getSyncStatus();
    setState(() {
      _lastSyncTime = syncStatus['lastSyncTime'];
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Future<void> _toggleOfflineMode(bool value) async {
    await _offlineManager.toggleOfflineMode(value);
    await _saveSetting('offline_mode_enabled', value);
    
    setState(() {
      _isOfflineMode = value;
    });
    
    if (!value) {
      // If disabling offline mode, attempt to sync
      _offlineManager.attemptSyncWhenOnline();
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    await _saveSetting('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    await _saveSetting('dark_mode_enabled', value);
    setState(() {
      _darkModeEnabled = value;
    });
    
    // Notify parent about theme change
    widget.onThemeChanged?.call(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _changeLanguage(String languageCode) async {
    await _saveSetting('selected_language', languageCode);
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  Future<void> _manualSync() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Syncing data...')),
    );
    
    await _offlineManager.attemptSyncWhenOnline();
    
    // Refresh sync status
    final syncStatus = await _offlineManager.getSyncStatus();
    setState(() {
      _lastSyncTime = syncStatus['lastSyncTime'];
    });
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data sync completed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'General Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Offline Mode Toggle
              Card(
                child: ListTile(
                  title: const Text('Offline Mode'),
                  subtitle: const Text('Enable offline functionality'),
                  trailing: Switch(
                    value: _isOfflineMode,
                    onChanged: _toggleOfflineMode,
                    activeColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              // Notifications Toggle
              Card(
                child: ListTile(
                  title: const Text('Notifications'),
                  subtitle: const Text('Enable push notifications'),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                    activeColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              // Dark Mode Toggle
              Card(
                child: ListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable dark theme'),
                  trailing: Switch(
                    value: _darkModeEnabled,
                    onChanged: _toggleDarkMode,
                    activeColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              const Text(
                'Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Language Selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Language',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _selectedLanguage,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _changeLanguage(newValue);
                          }
                        },
                        items: <String>['en', 'hi', 'mr', 'ta', 'te', 'kn']
                            .map<DropdownMenuItem<String>>((String value) {
                          String languageName = 'English';
                          switch (value) {
                            case 'hi':
                              languageName = 'Hindi';
                              break;
                            case 'mr':
                              languageName = 'Marathi';
                              break;
                            case 'ta':
                              languageName = 'Tamil';
                              break;
                            case 'te':
                              languageName = 'Telugu';
                              break;
                            case 'kn':
                              languageName = 'Kannada';
                              break;
                          }
                          
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(languageName),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              const Text(
                'Data Sync',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Sync Status
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sync Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            _lastSyncTime != null ? Icons.check_circle : Icons.error,
                            color: _lastSyncTime != null ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _lastSyncTime != null
                                  ? 'Last synced: ${_lastSyncTime!.toString().split(' ').first}'
                                  : 'Never synced',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              // Manual Sync Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _manualSync,
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // App Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FARM UP - Complete Smart Farming Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Version 1.0.0'),
                      const SizedBox(height: 5),
                      const Text('© 2025 FARM UP Team'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}