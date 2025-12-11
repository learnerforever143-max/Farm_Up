import 'dart:math';
import 'package:farm_up/models/disease_record.dart';
import 'package:farm_up/services/notification_manager.dart';

class DiseaseDetectionService {
  List<DiseaseRecord> _diseaseRecords = [];
  final NotificationManager _notificationManager = NotificationManager();
  
  // Simulated database of plant diseases
  final List<Map<String, dynamic>> _diseaseDatabase = [
    {
      'name': 'Wheat Rust',
      'scientificName': 'Puccinia triticina',
      'symptoms': ['Yellowish spots on leaves', 'Orange spores on leaf surface', 'Premature leaf death'],
      'severity': 'High',
      'treatment': 'Apply fungicides containing propiconazole or tebuconazole. Remove infected plant parts.',
      'prevention': 'Plant resistant varieties, rotate crops, ensure proper spacing for air circulation.'
    },
    {
      'name': 'Blight',
      'scientificName': 'Phytophthora infestans',
      'symptoms': ['Dark lesions on leaves', 'Water-soaked spots', 'White fungal growth on undersides'],
      'severity': 'High',
      'treatment': 'Use copper-based fungicides. Remove affected plants immediately.',
      'prevention': 'Avoid overhead watering, ensure good drainage, apply preventive fungicides.'
    },
    {
      'name': 'Powdery Mildew',
      'scientificName': 'Erysiphe graminis',
      'symptoms': ['White powdery coating on leaves', 'Leaf yellowing', 'Stunted growth'],
      'severity': 'Medium',
      'treatment': 'Apply sulfur-based fungicides or neem oil. Improve air circulation.',
      'prevention': 'Space plants properly, avoid excess nitrogen fertilization, water at soil level.'
    },
    {
      'name': 'Aphid Infestation',
      'scientificName': 'Aphidoidea',
      'symptoms': ['Curling leaves', 'Sticky honeydew residue', 'Small green/brown insects on stems'],
      'severity': 'Medium',
      'treatment': 'Spray with insecticidal soap or neem oil. Introduce beneficial insects like ladybugs.',
      'prevention': 'Encourage natural predators, remove weeds, monitor plants regularly.'
    },
    {
      'name': 'Fusarium Wilt',
      'scientificName': 'Fusarium oxysporum',
      'symptoms': ['Yellowing starting from base', 'Wilting despite adequate water', 'Brown vascular tissue'],
      'severity': 'High',
      'treatment': 'Remove infected plants. Solarize soil. Apply beneficial microbes.',
      'prevention': 'Use disease-free seeds, rotate crops, maintain soil health with compost.'
    }
  ];
  
  // Simulate disease detection from image
  Future<DiseaseRecord> detectDisease(String imagePath) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Randomly select a disease from the database for demonstration
    final random = Random();
    final diseaseIndex = random.nextInt(_diseaseDatabase.length);
    final diseaseData = _diseaseDatabase[diseaseIndex];
    
    // Create disease record
    final record = DiseaseRecord(
      cropName: 'Wheat', // Would come from image analysis in real app
      diseaseName: diseaseData['name'],
      scientificName: diseaseData['scientificName'],
      imageUrl: imagePath,
      symptoms: List<String>.from(diseaseData['symptoms']),
      severity: diseaseData['severity'],
      treatment: diseaseData['treatment'],
      prevention: diseaseData['prevention'],
      diagnosisDate: DateTime.now(),
      status: 'Detected',
    );
    
    // Add to records
    _diseaseRecords.add(record);
    
    // Send notification for high severity diseases
    if (record.severity == 'High') {
      await _notificationManager.sendDiseaseAlert(record);
    }
    
    return record;
  }
  
  // Get all disease records
  List<DiseaseRecord> getAllDiseaseRecords() {
    return List.from(_diseaseRecords);
  }
  
  // Get disease records by crop
  List<DiseaseRecord> getDiseaseRecordsByCrop(String cropName) {
    return _diseaseRecords
        .where((record) => record.cropName.toLowerCase() == cropName.toLowerCase())
        .toList();
  }
  
  // Get recent disease records (within last N days)
  List<DiseaseRecord> getRecentDiseaseRecords(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _diseaseRecords
        .where((record) => record.diagnosisDate.isAfter(cutoffDate))
        .toList();
  }
  
  // Update disease record status
  void updateDiseaseRecordStatus(int recordId, String newStatus) {
    final index = _diseaseRecords.indexWhere((record) => record.id == recordId);
    if (index != -1) {
      _diseaseRecords[index] = DiseaseRecord(
        id: _diseaseRecords[index].id,
        cropName: _diseaseRecords[index].cropName,
        diseaseName: _diseaseRecords[index].diseaseName,
        scientificName: _diseaseRecords[index].scientificName,
        imageUrl: _diseaseRecords[index].imageUrl,
        symptoms: _diseaseRecords[index].symptoms,
        severity: _diseaseRecords[index].severity,
        treatment: _diseaseRecords[index].treatment,
        prevention: _diseaseRecords[index].prevention,
        diagnosisDate: _diseaseRecords[index].diagnosisDate,
        status: newStatus,
      );
    }
  }
  
  // Get disease statistics
  Map<String, dynamic> getDiseaseStats() {
    final stats = <String, dynamic>{};
    
    // Total records
    stats['totalRecords'] = _diseaseRecords.length;
    
    // Records by severity
    final severityCount = <String, int>{};
    for (final record in _diseaseRecords) {
      if (severityCount.containsKey(record.severity)) {
        severityCount[record.severity] = severityCount[record.severity]! + 1;
      } else {
        severityCount[record.severity] = 1;
      }
    }
    stats['severityDistribution'] = severityCount;
    
    // Records by status
    final statusCount = <String, int>{};
    for (final record in _diseaseRecords) {
      if (statusCount.containsKey(record.status)) {
        statusCount[record.status] = statusCount[record.status]! + 1;
      } else {
        statusCount[record.status] = 1;
      }
    }
    stats['statusDistribution'] = statusCount;
    
    return stats;
  }
  
  // Get prevention tips for all recorded diseases
  List<String> getPreventionTips() {
    final tips = <String>{};
    for (final record in _diseaseRecords) {
      tips.addAll(record.prevention);
    }
    return tips.toList();
  }
  
  // Send disease alert notification
  Future<void> sendDiseaseAlert(DiseaseRecord record) async {
    await _notificationManager.sendDiseaseAlert(record);
  }
}