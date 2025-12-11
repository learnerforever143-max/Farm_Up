import 'dart:async';
import 'package:farm_up/models/user.dart';

class AuthService {
  User? _currentUser;
  final Map<String, User> _users = {}; // In-memory storage for demo purposes
  
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  User? get currentUser => _currentUser;
  
  // Simulate user registration
  Future<User> registerUser({
    required String fullName,
    required String phoneNumber,
    String? email,
    String languagePreference = 'en',
  }) async {
    // Check if user already exists
    if (_users.containsKey(phoneNumber)) {
      throw Exception('User with this phone number already exists');
    }
    
    // Create new user
    final user = User(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      languagePreference: languagePreference,
      registrationDate: DateTime.now(),
      lastLogin: DateTime.now(),
    );
    
    // Save user (in a real app, this would be to a database)
    _users[phoneNumber] = user;
    _currentUser = user;
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return user;
  }
  
  // Simulate user login
  Future<User> loginUser(String phoneNumber) async {
    // Check if user exists
    if (!_users.containsKey(phoneNumber)) {
      throw Exception('No user found with this phone number');
    }
    
    // Update last login
    final user = _users[phoneNumber]!;
    final updatedUser = User(
      userId: user.userId,
      fullName: user.fullName,
      phoneNumber: user.phoneNumber,
      email: user.email,
      languagePreference: user.languagePreference,
      registrationDate: user.registrationDate,
      lastLogin: DateTime.now(),
    );
    
    // Update in storage
    _users[phoneNumber] = updatedUser;
    _currentUser = updatedUser;
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return updatedUser;
  }
  
  // Simulate logout
  Future<void> logout() async {
    _currentUser = null;
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  // Check if user is authenticated
  bool isAuthenticated() {
    return _currentUser != null;
  }
  
  // Get all users (for admin purposes)
  List<User> getAllUsers() {
    return _users.values.toList();
  }
}