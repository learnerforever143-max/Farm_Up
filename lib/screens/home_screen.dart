import 'package:flutter/material.dart';
import 'package:farm_up/screens/dashboard_screen.dart';
import 'package:farm_up/screens/ai_assistant_screen.dart';
import 'package:farm_up/screens/market_trends_screen.dart';
import 'package:farm_up/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  
  const HomeScreen({super.key, this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('dark_mode_enabled') ?? false;
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    AIAssistantScreen(),
    MarketTrendsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() async {
    final newThemeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _themeMode = newThemeMode;
    });
    
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode_enabled', newThemeMode == ThemeMode.dark);
    
    // Notify parent
    widget.onThemeChanged?.call(newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FARM UP'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _themeMode == ThemeMode.light 
                ? Icons.dark_mode 
                : Icons.light_mode,
            ),
            onPressed: _toggleTheme,
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'AI Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Market Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}