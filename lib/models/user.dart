class User {
  final int? userId;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String languagePreference;
  final DateTime registrationDate;
  final DateTime? lastLogin;

  User({
    this.userId,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.languagePreference = 'en',
    required this.registrationDate,
    this.lastLogin,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'languagePreference': languagePreference,
      'registrationDate': registrationDate.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      languagePreference: json['languagePreference'] ?? 'en',
      registrationDate: DateTime.parse(json['registrationDate']),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
    );
  }
}