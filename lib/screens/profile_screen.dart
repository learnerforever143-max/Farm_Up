import 'package:flutter/material.dart';
import 'package:farm_up/services/auth_service.dart';
import 'package:farm_up/models/user.dart';
import 'package:farm_up/screens/settings_screen.dart';
import 'package:farm_up/screens/report_export_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  
  const ProfileScreen({super.key, this.onThemeChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _user = _authService.currentUser;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    
    // Navigate to auth screen
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (_user != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _user!.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _user!.phoneNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      if (_user!.email != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _user!.email!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Language: ${_user!.languagePreference}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Member since: ${_user!.registrationDate.toString().split(' ').first}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Language'),
                  subtitle: Text(_user!.languagePreference),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to language settings
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Notifications'),
                  subtitle: const Text('Enabled'),
                  trailing: const Switch(value: true, onChanged: null),
                  onTap: () {
                    // Navigate to notification settings
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Settings'),
                  subtitle: const Text('Offline mode, sync, and more'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to settings screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          onThemeChanged: widget.onThemeChanged,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text('Export Reports'),
                  subtitle: const Text('Generate PDF and Excel reports'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to report export screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportExportScreen(),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              const Center(
                child: Text('No user data available'),
              ),
            ],
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}