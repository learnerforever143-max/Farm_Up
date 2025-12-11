class WaterSchedule {
  final int? id;
  final String cropType;
  final double soilMoisture;
  final double temperature;
  final double humidity;
  final DateTime scheduledTime;
  final double waterAmountLiters;
  final String irrigationMethod;
  final bool isCompleted;

  WaterSchedule({
    this.id,
    required this.cropType,
    required this.soilMoisture,
    required this.temperature,
    required this.humidity,
    required this.scheduledTime,
    required this.waterAmountLiters,
    required this.irrigationMethod,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropType': cropType,
      'soilMoisture': soilMoisture,
      'temperature': temperature,
      'humidity': humidity,
      'scheduledTime': scheduledTime.toIso8601String(),
      'waterAmountLiters': waterAmountLiters,
      'irrigationMethod': irrigationMethod,
      'isCompleted': isCompleted,
    };
  }

  factory WaterSchedule.fromJson(Map<String, dynamic> json) {
    return WaterSchedule(
      id: json['id'],
      cropType: json['cropType'],
      soilMoisture: json['soilMoisture'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      waterAmountLiters: json['waterAmountLiters'],
      irrigationMethod: json['irrigationMethod'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}