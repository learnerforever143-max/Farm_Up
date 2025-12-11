import 'package:flutter/material.dart';
import 'package:farm_up/services/water_management_service.dart';
import 'package:farm_up/models/water_schedule.dart';

class WaterManagementScreen extends StatefulWidget {
  const WaterManagementScreen({super.key});

  @override
  State<WaterManagementScreen> createState() => _WaterManagementScreenState();
}

class _WaterManagementScreenState extends State<WaterManagementScreen> {
  final WaterManagementService _waterService = WaterManagementService();
  List<WaterSchedule> _upcomingSchedules = [];
  List<WaterSchedule> _completedSchedules = [];
  List<String> _conservationTips = [];
  bool _isLoading = true;

  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _moistureController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWaterData();
  }

  @override
  void dispose() {
    _cropController.dispose();
    _areaController.dispose();
    _moistureController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    super.dispose();
  }

  Future<void> _loadWaterData() async {
    setState(() {
      _isLoading = true;
    });

    // Load conservation tips
    _conservationTips = _waterService.getWaterConservationTips();

    setState(() {
      _isLoading = false;
    });
  }

  void _generateSchedule() {
    if (_cropController.text.isEmpty ||
        _areaController.text.isEmpty ||
        _moistureController.text.isEmpty ||
        _temperatureController.text.isEmpty ||
        _humidityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final schedules = _waterService.generateWeeklySchedule(
      cropType: _cropController.text,
      areaHectares: double.tryParse(_areaController.text) ?? 1.0,
      soilMoisture: double.tryParse(_moistureController.text) ?? 50.0,
      temperature: double.tryParse(_temperatureController.text) ?? 25.0,
      humidity: double.tryParse(_humidityController.text) ?? 60.0,
    );

    setState(() {
      _upcomingSchedules = schedules.where((s) => !s.isCompleted).toList();
      _completedSchedules = schedules.where((s) => s.isCompleted).toList();
    });
  }

  void _markAsCompleted(WaterSchedule schedule) {
    _waterService.markAsCompleted(schedule.id ?? 0);
    _loadWaterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Management'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Water Management System',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Optimize irrigation scheduling and water usage',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Water Requirement Calculator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _cropController,
                        decoration: const InputDecoration(
                          labelText: 'Crop Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _areaController,
                        decoration: const InputDecoration(
                          labelText: 'Area (hectares)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _moistureController,
                        decoration: const InputDecoration(
                          labelText: 'Soil Moisture (%)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _temperatureController,
                        decoration: const InputDecoration(
                          labelText: 'Temperature (°C)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _humidityController,
                        decoration: const InputDecoration(
                          labelText: 'Humidity (%)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _generateSchedule,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Generate Schedule'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                if (_upcomingSchedules.isNotEmpty) ...[
                  const Text(
                    'Upcoming Irrigation Schedule',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _upcomingSchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = _upcomingSchedules[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            '${schedule.scheduledTime.day}/${schedule.scheduledTime.month} - ${schedule.irrigationMethod}',
                          ),
                          subtitle: Text(
                            '${schedule.waterAmountLiters.toStringAsFixed(0)} liters • ${schedule.cropType}',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _markAsCompleted(schedule),
                            child: const Text('Mark Done'),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
                if (_completedSchedules.isNotEmpty) ...[
                  const Text(
                    'Completed Irrigations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _completedSchedules.length,
                    itemBuilder: (context, index) {
                      final schedule = _completedSchedules[index];
                      return Card(
                        color: Colors.grey[200],
                        child: ListTile(
                          title: Text(
                            '${schedule.scheduledTime.day}/${schedule.scheduledTime.month} - ${schedule.irrigationMethod}',
                          ),
                          subtitle: Text(
                            '${schedule.waterAmountLiters.toStringAsFixed(0)} liters • ${schedule.cropType}',
                          ),
                          trailing: const Icon(Icons.check_circle, color: Colors.green),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Water Conservation Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _conservationTips.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.water_drop, color: Colors.blue),
                        title: Text(_conservationTips[index]),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}