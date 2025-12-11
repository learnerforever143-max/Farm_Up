import 'package:flutter/material.dart';
import 'package:farm_up/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  List<WeatherForecast> _forecast = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWeatherForecast();
  }

  Future<void> _loadWeatherForecast() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // In a real app, you would get the user's location
      // For this demo, we'll use a fixed location
      final forecast = await _weatherService.get7DayForecast(18.5204, 73.8567); // Pune, India coordinates
      setState(() {
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load weather forecast: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadWeatherForecast,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '7-Day Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Plan your farming activities based on weather predictions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_errorMessage.isNotEmpty)
                  Center(
                    child: Column(
                      children: [
                        Text(_errorMessage),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _loadWeatherForecast,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      // Current weather highlight
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (_forecast.isNotEmpty) ...[
                                Text(
                                  _weatherService.getWeatherIcon(_forecast[0].condition),
                                  style: const TextStyle(fontSize: 48),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${_forecast[0].temperature.toStringAsFixed(1)}°C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _forecast[0].condition,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _weatherService.getAgriculturalAdvice(_forecast[0].condition),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '7-Day Forecast',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _forecast.length,
                        itemBuilder: (context, index) {
                          final day = _forecast[index];
                          return Card(
                            child: ListTile(
                              leading: Text(
                                _weatherService.getWeatherIcon(day.condition),
                                style: const TextStyle(fontSize: 24),
                              ),
                              title: Text(
                                index == 0
                                    ? 'Today'
                                    : index == 1
                                        ? 'Tomorrow'
                                        : '${day.date.weekday == 1 ? 'Mon' : day.date.weekday == 2 ? 'Tue' : day.date.weekday == 3 ? 'Wed' : day.date.weekday == 4 ? 'Thu' : day.date.weekday == 5 ? 'Fri' : day.date.weekday == 6 ? 'Sat' : 'Sun'}, ${day.date.day}/${day.date.month}',
                              ),
                              subtitle: Text(day.condition),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${day.temperature.toStringAsFixed(1)}°C'),
                                  Text(
                                    '${day.precipitationChance.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Agricultural Insights',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Weather-Based Recommendations:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              const Text('• Irrigation: Adjust watering schedule based on rainfall predictions'),
                              const Text('• Planting: Optimal conditions for seed germination in the next 2 days'),
                              const Text('• Harvesting: Schedule harvest before the rainy period begins'),
                              const Text('• Pest Control: Increased humidity may lead to fungal growth'),
                              const SizedBox(height: 10),
                              const Text(
                                'Alerts:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              const Text('⚠️ Heavy rain expected in 3 days. Prepare drainage systems.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}