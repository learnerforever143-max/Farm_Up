class SoilData {
  final double pH;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double moisture;

  SoilData({
    required this.pH,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.moisture,
  });

  Map<String, dynamic> toJson() {
    return {
      'pH': pH,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'moisture': moisture,
    };
  }

  factory SoilData.fromJson(Map<String, dynamic> json) {
    return SoilData(
      pH: json['pH'],
      nitrogen: json['nitrogen'],
      phosphorus: json['phosphorus'],
      potassium: json['potassium'],
      moisture: json['moisture'],
    );
  }
}