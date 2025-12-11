import 'package:farm_up/models/water_schedule.dart';
import 'package:farm_up/services/notification_manager.dart';

class WaterManagementService {
  List<WaterSchedule> _schedules = [];
  final NotificationManager _notificationManager = NotificationManager();
  
  // Calculate water requirement based on crop type and environmental factors
  double calculateWaterRequirement({
    required String cropType,
    required double soilMoisture,
    required double temperature,
    required double humidity,
    required double areaHectares,
  }) {
    // Base water requirement per day in liters per square meter
    double baseRequirement = _getBaseWaterRequirement(cropType);
    
    // Adjust based on soil moisture (less water if soil is moist)
    double moistureFactor = 1.0 - (soilMoisture / 100);
    
    // Adjust based on temperature (more water if hotter)
    double temperatureFactor = 1.0 + ((temperature - 25) / 100);
    
    // Adjust based on humidity (less water if more humid)
    double humidityFactor = 1.0 - ((humidity - 50) / 200);
    
    // Calculate total water requirement for the area
    double totalRequirement = baseRequirement * 
                             moistureFactor * 
                             temperatureFactor * 
                             humidityFactor * 
                             areaHectares * 
                             10000; // Convert hectares to square meters
    
    return totalRequirement;
  }
  
  double _getBaseWaterRequirement(String cropType) {
    // Water requirements in liters per square meter per day
    switch (cropType.toLowerCase()) {
      case 'rice':
        return 5.0; // Rice requires a lot of water
      case 'wheat':
        return 2.5;
      case 'corn':
        return 3.0;
      case 'tomatoes':
        return 2.0;
      case 'lettuce':
        return 1.5;
      default:
        return 2.0; // Default moderate requirement
    }
  }
  
  String recommendIrrigationMethod({
    required String cropType,
    required double soilMoisture,
    required double temperature,
    required double waterRequirement,
  }) {
    // Drip irrigation is most efficient for most crops
    if (waterRequirement > 10000) { // Large water requirement
      return 'Drip Irrigation';
    } else if (temperature > 35) { // High temperature
      return 'Drip Irrigation'; // More efficient in hot weather
    } else if (soilMoisture < 30) { // Dry soil
      return 'Drip Irrigation'; // Targeted watering
    } else {
      return 'Sprinkler System'; // General purpose
    }
  }
  
  // Generate irrigation schedule for the next 7 days
  List<WaterSchedule> generateWeeklySchedule({
    required String cropType,
    required double soilMoisture,
    required double temperature,
    required double humidity,
    required double areaHectares,
  }) {
    List<WaterSchedule> schedule = [];
    DateTime now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      DateTime scheduledTime = now.add(Duration(days: i));
      
      // Skip if it's raining (based on a simple heuristic)
      bool isRaining = (i == 2 || i == 5); // Just for demo purposes
      
      if (!isRaining) {
        double waterAmount = calculateWaterRequirement(
          cropType: cropType,
          soilMoisture: soilMoisture,
          temperature: temperature + (i * 0.5), // Gradually increasing temperature
          humidity: humidity - (i * 2), // Gradually decreasing humidity
          areaHectares: areaHectares,
        );
        
        String irrigationMethod = recommendIrrigationMethod(
          cropType: cropType,
          soilMoisture: soilMoisture,
          temperature: temperature,
          waterRequirement: waterAmount,
        );
        
        schedule.add(WaterSchedule(
          cropType: cropType,
          soilMoisture: soilMoisture,
          temperature: temperature,
          humidity: humidity,
          scheduledTime: scheduledTime,
          waterAmountLiters: waterAmount,
          irrigationMethod: irrigationMethod,
        ));
      }
    }
    
    _schedules = schedule;
    return schedule;
  }
  
  // Mark a scheduled irrigation as completed
  void markAsCompleted(int scheduleId) {
    for (int i = 0; i < _schedules.length; i++) {
      if (_schedules[i].id == scheduleId) {
        _schedules[i] = WaterSchedule(
          id: _schedules[i].id,
          cropType: _schedules[i].cropType,
          soilMoisture: _schedules[i].soilMoisture,
          temperature: _schedules[i].temperature,
          humidity: _schedules[i].humidity,
          scheduledTime: _schedules[i].scheduledTime,
          waterAmountLiters: _schedules[i].waterAmountLiters,
          irrigationMethod: _schedules[i].irrigationMethod,
          isCompleted: true,
        );
        break;
      }
    }
  }
  
  // Get upcoming schedules
  List<WaterSchedule> getUpcomingSchedules() {
    DateTime now = DateTime.now();
    return _schedules.where((schedule) => 
      schedule.scheduledTime.isAfter(now) && !schedule.isCompleted
    ).toList();
  }
  
  // Get upcoming schedules within a date range
  List<WaterSchedule> getUpcomingIrrigationSchedules(DateTime startDate, DateTime endDate) {
    return _schedules.where((schedule) => 
      schedule.scheduledTime.isAfter(startDate) && 
      schedule.scheduledTime.isBefore(endDate) && 
      !schedule.isCompleted
    ).toList();
  }
  
  // Get completed schedules
  List<WaterSchedule> getCompletedSchedules() {
    return _schedules.where((schedule) => schedule.isCompleted).toList();
  }
  
  // Water conservation tips
  List<String> getWaterConservationTips() {
    return [
      "Use mulch to reduce evaporation from soil",
      "Install drip irrigation for targeted watering",
      "Water during early morning or evening to reduce evaporation",
      "Collect and use rainwater when possible",
      "Regularly check for leaks in irrigation systems",
      "Plant drought-resistant crop varieties",
      "Use soil moisture sensors for precise irrigation timing",
      "Create swales to capture and infiltrate runoff water"
    ];
  }
  
  // Send irrigation reminder notification
  Future<void> sendIrrigationReminder(WaterSchedule schedule) async {
    await _notificationManager.sendIrrigationReminder(schedule);
  }
}