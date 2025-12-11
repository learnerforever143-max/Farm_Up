class DiseaseDetection {
  final int? id;
  final String imagePath;
  final String detectedDisease;
  final String diseaseDescription;
  final double confidenceScore;
  final List<String> treatmentOptions;
  final List<String> preventionTips;
  final DateTime detectionDate;
  final bool treatmentApplied;

  DiseaseDetection({
    this.id,
    required this.imagePath,
    required this.detectedDisease,
    required this.diseaseDescription,
    required this.confidenceScore,
    required this.treatmentOptions,
    required this.preventionTips,
    required this.detectionDate,
    this.treatmentApplied = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'detectedDisease': detectedDisease,
      'diseaseDescription': diseaseDescription,
      'confidenceScore': confidenceScore,
      'treatmentOptions': treatmentOptions,
      'preventionTips': preventionTips,
      'detectionDate': detectionDate.toIso8601String(),
      'treatmentApplied': treatmentApplied,
    };
  }

  factory DiseaseDetection.fromJson(Map<String, dynamic> json) {
    return DiseaseDetection(
      id: json['id'],
      imagePath: json['imagePath'],
      detectedDisease: json['detectedDisease'],
      diseaseDescription: json['diseaseDescription'],
      confidenceScore: json['confidenceScore'],
      treatmentOptions: List<String>.from(json['treatmentOptions']),
      preventionTips: List<String>.from(json['preventionTips']),
      detectionDate: DateTime.parse(json['detectionDate']),
      treatmentApplied: json['treatmentApplied'] ?? false,
    );
  }
}