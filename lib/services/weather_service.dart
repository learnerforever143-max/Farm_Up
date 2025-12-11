class WeatherForecast {
  final DateTime date;
  final double temperature;
  final String condition;
  final double precipitationChance;
  final double humidity;
  final double windSpeed;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.precipitationChance,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date']),
      temperature: json['temperature'],
      condition: json['condition'],
      precipitationChance: json['precipitationChance'],
      humidity: json['humidity'],
      windSpeed: json['windSpeed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'temperature': temperature,
      'condition': condition,
      'precipitationChance': precipitationChance,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }
}

class WeatherService {
  // In a real implementation, this would call a weather API
  // For this demo, we'll generate mock data
  
  Future<List<WeatherForecast>> get7DayForecast(double latitude, double longitude) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    final List<WeatherForecast> forecast = [];
    final now = DateTime.now();
    
    // Generate 7 days of forecast data
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      
      // Generate realistic weather data
      final baseTemp = 25.0; // Base temperature in Celsius
      final tempVariation = 10.0 * (i ~/ 2); // Increase variation with days
      final temperature = baseTemp + (tempVariation * (0.5 - (i % 2))); // Alternating warmer/cooler
      
      final conditions = ['Sunny', 'Partly Cloudy', 'Cloudy', 'Rainy', 'Thunderstorms'];
      final condition = conditions[i % conditions.length];
      
      final precipitationChance = i > 3 ? (i * 15.0) : (i * 5.0); // Increasing chance of rain
      final humidity = 40.0 + (i * 5.0); // Increasing humidity
      final windSpeed = 5.0 + (i * 2.0); // Increasing wind speed
      
      forecast.add(WeatherForecast(
        date: date,
        temperature: temperature,
        condition: condition,
        precipitationChance: precipitationChance,
        humidity: humidity,
        windSpeed: windSpeed,
      ));
    }
    
    return forecast;
  }
  
  String getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return '☀️';
      case 'partly cloudy':
        return '⛅';
      case 'cloudy':
        return '☁️';
      case 'rainy':
        return '🌧️';
      case 'thunderstorms':
        return '⛈️';
      default:
        return '🌤️';
    }
  }
  
  String getAgriculturalAdvice(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return 'Good weather for harvesting and outdoor activities. Protect plants from excessive heat.';
      case 'partly cloudy':
        return 'Ideal conditions for most farming activities. Monitor soil moisture.';
      case 'cloudy':
        return 'Overcast conditions. Good for delicate plants that need protection from direct sun.';
      case 'rainy':
        return 'Rain expected. Delay spraying pesticides/herbicides. Ensure proper drainage.';
      case 'thunderstorms':
        return 'Severe weather alert! Secure equipment and protect livestock. Postpone outdoor activities.';
      default:
        return 'Monitor weather conditions closely.';
    }
  }
}