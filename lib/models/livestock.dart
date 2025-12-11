class Livestock {
  final int? id;
  final String name;
  final String type; // Cow, Goat, Sheep, Pig, Chicken, etc.
  final String breed;
  final DateTime dateOfBirth;
  final String gender; // Male or Female
  final double weight;
  final String healthStatus; // Healthy, Sick, Under Treatment, etc.
  final List<VaccinationRecord> vaccinationRecords;
  final List<HealthCheckup> healthCheckups;
  final List<FeedingRecord> feedingRecords;
  final DateTime purchaseDate;
  final double purchasePrice;
  final String notes;

  Livestock({
    this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.dateOfBirth,
    required this.gender,
    required this.weight,
    this.healthStatus = 'Healthy',
    List<VaccinationRecord>? vaccinationRecords,
    List<HealthCheckup>? healthCheckups,
    List<FeedingRecord>? feedingRecords,
    required this.purchaseDate,
    required this.purchasePrice,
    this.notes = '',
  })  : vaccinationRecords = vaccinationRecords ?? [],
        healthCheckups = healthCheckups ?? [],
        feedingRecords = feedingRecords ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'healthStatus': healthStatus,
      'vaccinationRecords': vaccinationRecords.map((v) => v.toJson()).toList(),
      'healthCheckups': healthCheckups.map((h) => h.toJson()).toList(),
      'feedingRecords': feedingRecords.map((f) => f.toJson()).toList(),
      'purchaseDate': purchaseDate.toIso8601String(),
      'purchasePrice': purchasePrice,
      'notes': notes,
    };
  }

  factory Livestock.fromJson(Map<String, dynamic> json) {
    return Livestock(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      breed: json['breed'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      gender: json['gender'],
      weight: json['weight'],
      healthStatus: json['healthStatus'] ?? 'Healthy',
      vaccinationRecords: (json['vaccinationRecords'] as List)
          .map((v) => VaccinationRecord.fromJson(v))
          .toList(),
      healthCheckups: (json['healthCheckups'] as List)
          .map((h) => HealthCheckup.fromJson(h))
          .toList(),
      feedingRecords: (json['feedingRecords'] as List)
          .map((f) => FeedingRecord.fromJson(f))
          .toList(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      purchasePrice: json['purchasePrice'],
      notes: json['notes'] ?? '',
    );
  }

  int get ageInDays {
    return DateTime.now().difference(dateOfBirth).inDays;
  }

  int get ageInMonths {
    return (ageInDays / 30).floor();
  }

  int get ageInYears {
    return (ageInDays / 365).floor();
  }
}

class VaccinationRecord {
  final int? id;
  final String vaccineName;
  final DateTime vaccinationDate;
  final DateTime nextDueDate;
  final String veterinarian;
  final String notes;

  VaccinationRecord({
    this.id,
    required this.vaccineName,
    required this.vaccinationDate,
    required this.nextDueDate,
    required this.veterinarian,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccineName': vaccineName,
      'vaccinationDate': vaccinationDate.toIso8601String(),
      'nextDueDate': nextDueDate.toIso8601String(),
      'veterinarian': veterinarian,
      'notes': notes,
    };
  }

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) {
    return VaccinationRecord(
      id: json['id'],
      vaccineName: json['vaccineName'],
      vaccinationDate: DateTime.parse(json['vaccinationDate']),
      nextDueDate: DateTime.parse(json['nextDueDate']),
      veterinarian: json['veterinarian'],
      notes: json['notes'] ?? '',
    );
  }
}

class HealthCheckup {
  final int? id;
  final DateTime checkupDate;
  final String diagnosis;
  final String treatment;
  final DateTime followUpDate;
  final String veterinarian;
  final String notes;

  HealthCheckup({
    this.id,
    required this.checkupDate,
    required this.diagnosis,
    required this.treatment,
    required this.followUpDate,
    required this.veterinarian,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkupDate': checkupDate.toIso8601String(),
      'diagnosis': diagnosis,
      'treatment': treatment,
      'followUpDate': followUpDate.toIso8601String(),
      'veterinarian': veterinarian,
      'notes': notes,
    };
  }

  factory HealthCheckup.fromJson(Map<String, dynamic> json) {
    return HealthCheckup(
      id: json['id'],
      checkupDate: DateTime.parse(json['checkupDate']),
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      followUpDate: DateTime.parse(json['followUpDate']),
      veterinarian: json['veterinarian'],
      notes: json['notes'] ?? '',
    );
  }
}

class FeedingRecord {
  final int? id;
  final DateTime feedDate;
  final String feedType;
  final double quantity;
  final String unit; // kg, lbs, etc.
  final String notes;

  FeedingRecord({
    this.id,
    required this.feedDate,
    required this.feedType,
    required this.quantity,
    this.unit = 'kg',
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feedDate': feedDate.toIso8601String(),
      'feedType': feedType,
      'quantity': quantity,
      'unit': unit,
      'notes': notes,
    };
  }

  factory FeedingRecord.fromJson(Map<String, dynamic> json) {
    return FeedingRecord(
      id: json['id'],
      feedDate: DateTime.parse(json['feedDate']),
      feedType: json['feedType'],
      quantity: json['quantity'],
      unit: json['unit'] ?? 'kg',
      notes: json['notes'] ?? '',
    );
  }
}