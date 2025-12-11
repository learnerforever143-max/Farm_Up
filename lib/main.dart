import 'package:flutter/material.dart';
import 'package:farm_up/screens/home_screen.dart';
import 'package:farm_up/screens/auth_screen.dart';
import 'package:farm_up/services/auth_service.dart';
import 'package:farm_up/models/user.dart';
import 'package:farm_up/services/offline_manager.dart';
import 'package:farm_up/services/notification_manager.dart';
import 'package:farm_up/services/theme_service.dart';

void main() {
  runApp(const FarmUpApp());
}

class FarmUpApp extends StatefulWidget {
  const FarmUpApp({super.key});

  @override
  State<FarmUpApp> createState() => _FarmUpAppState();
}

class _FarmUpAppState extends State<FarmUpApp> {
  final AuthService _authService = AuthService();
  final OfflineManager _offlineManager = OfflineManager();
  final NotificationManager _notificationManager = NotificationManager();
  final ThemeService _themeService = ThemeService();
  bool _isLoggedIn = false;
  bool _isInitialized = false;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    // Initialize offline manager
    await _offlineManager.initialize();
    
    // Initialize notification manager
    await _notificationManager.initialize();
    
    // Load theme mode
    _themeMode = await _themeService.getThemeMode();
    
    // Check authentication
    setState(() {
      _isLoggedIn = _authService.isAuthenticated();
      _isInitialized = true;
    });
  }

  void _handleAuthentication(User user) {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _themeService.saveThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Initializing FARM UP...'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'FARM UP',
      theme: _themeService.getLightTheme(),
      darkTheme: _themeService.getDarkTheme(),
      themeMode: _themeMode,
      home: _isLoggedIn
          ? HomeScreen(onThemeChanged: _changeTheme)
          : const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/auth': (context) => AuthScreen(onAuthenticated: _handleAuthentication),
        '/home': (context) => HomeScreen(onThemeChanged: _changeTheme),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Colors.grey[800]!, Colors.grey[900]!]
                : [Colors.green.shade50, Colors.green.shade200],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.agriculture,
                size: 100,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.greenAccent
                    : Colors.green,
              ),
              const SizedBox(height: 20),
              Text(
                'FARM UP',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.greenAccent
                      : Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Complete Smart Farming Assistant',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]!
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                'Empowering Every Farmer to Farm Smart, Earn Better!',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]!
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Features:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '• Soil Analysis & Crop Recommendation\n'
                '• Budget Calculator & Financial Planning\n'
                '• Real-Time Weather Forecasting\n'
                '• Water Management System\n'
                '• AI-Powered Disease Detection\n'
                '• Comprehensive Video Library\n'
                '• Offline Functionality with Cloud Sync\n'
                '• Smart Notifications & Alerts\n'
                '• Dark Mode Support',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]!
                      : Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.greenAccent
                        : Colors.green,
                    foregroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
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