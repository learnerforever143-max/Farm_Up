import 'package:flutter/material.dart';
import 'package:farm_up/services/livestock_service.dart';
import 'package:farm_up/models/livestock.dart';

class LivestockManagementScreen extends StatefulWidget {
  const LivestockManagementScreen({super.key});

  @override
  State<LivestockManagementScreen> createState() => _LivestockManagementScreenState();
}

class _LivestockManagementScreenState extends State<LivestockManagementScreen> {
  final LivestockService _livestockService = LivestockService();
  List<Livestock> _livestockList = [];
  List<String> _healthAlerts = [];
  List<String> _breedingRecommendations = [];
  Map<String, dynamic> _statistics = {};

  @override
  void initState() {
    super.initState();
    _loadLivestockData();
  }

  void _loadLivestockData() {
    // In a real app, this would fetch from a database
    // For demo purposes, we'll add some sample data
    _addSampleData();
    
    setState(() {
      _livestockList = _livestockService.getAllLivestock();
      _healthAlerts = _livestockService.getHealthAlerts();
      _breedingRecommendations = _livestockService.getBreedingRecommendations();
      _statistics = _livestockService.getLivestockStatistics();
    });
  }

  void _addSampleData() {
    // Sample livestock data for demonstration
    final cow1 = Livestock(
      name: 'Bessie',
      type: 'Cow',
      breed: 'Holstein',
      dateOfBirth: DateTime(2020, 5, 15),
      gender: 'Female',
      weight: 650.0,
      healthStatus: 'Healthy',
      purchaseDate: DateTime(2021, 3, 10),
      purchasePrice: 1200.0,
      notes: 'High milk production',
    );

    final cow2 = Livestock(
      name: 'Daisy',
      type: 'Cow',
      breed: 'Jersey',
      dateOfBirth: DateTime(2019, 8, 22),
      gender: 'Female',
      weight: 500.0,
      healthStatus: 'Under Treatment',
      purchaseDate: DateTime(2020, 6, 5),
      purchasePrice: 950.0,
      notes: 'Recently calved',
    );

    final goat1 = Livestock(
      name: 'Billy',
      type: 'Goat',
      breed: 'Boer',
      dateOfBirth: DateTime(2021, 1, 10),
      gender: 'Male',
      weight: 90.0,
      healthStatus: 'Healthy',
      purchaseDate: DateTime(2021, 12, 1),
      purchasePrice: 250.0,
      notes: 'Breeding buck',
    );

    _livestockService.addLivestock(cow1);
    _livestockService.addLivestock(cow2);
    _livestockService.addLivestock(goat1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livestock Management'),
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
                'Livestock Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Track your livestock health, breeding, and feeding',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Statistics Cards
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildStatCard('Total Animals', '${_statistics['totalAnimals'] ?? 0}', Colors.green),
                    const SizedBox(width: 10),
                    _buildStatCard('Total Value', '\$${(_statistics['totalValue'] ?? 0).toStringAsFixed(0)}', Colors.blue),
                    const SizedBox(width: 10),
                    _buildStatCard('Cows', '${(_statistics['typeCounts'] as Map?)?['Cow'] ?? 0}', Colors.orange),
                    const SizedBox(width: 10),
                    _buildStatCard('Goats', '${(_statistics['typeCounts'] as Map?)?['Goat'] ?? 0}', Colors.purple),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Health Alerts
              const Text(
                'Health Alerts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_healthAlerts.isEmpty)
                const Center(
                  child: Text('No health alerts'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _healthAlerts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: _healthAlerts[index].contains('requires attention') 
                          ? Colors.red[50] 
                          : Colors.green[50],
                      child: ListTile(
                        leading: Icon(
                          _healthAlerts[index].contains('requires attention') 
                              ? Icons.warning 
                              : Icons.check_circle,
                          color: _healthAlerts[index].contains('requires attention') 
                              ? Colors.red 
                              : Colors.green,
                        ),
                        title: Text(_healthAlerts[index]),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),
              // Breeding Recommendations
              const Text(
                'Breeding Recommendations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_breedingRecommendations.isEmpty)
                const Center(
                  child: Text('No breeding recommendations'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _breedingRecommendations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.family_restroom, color: Colors.green),
                        title: Text(_breedingRecommendations[index]),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),
              // Livestock List
              const Text(
                'Your Livestock',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (_livestockList.isEmpty)
                const Center(
                  child: Text('No livestock added yet'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _livestockList.length,
                  itemBuilder: (context, index) {
                    final livestock = _livestockList[index];
                    return Card(
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(livestock.type.substring(0, 1)),
                        ),
                        title: Text(livestock.name),
                        subtitle: Text('${livestock.type} - ${livestock.breed}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.cake, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Age: ${livestock.ageInYears} years',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.monitor_weight, size: 16),
                                    const SizedBox(width: 5),
                                    Text('Weight: ${livestock.weight} kg'),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Health: ${livestock.healthStatus}',
                                      style: TextStyle(
                                        color: livestock.healthStatus == 'Healthy' 
                                            ? Colors.green 
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 16),
                                    const SizedBox(width: 5),
                                    Text('Value: \$${livestock.purchasePrice.toStringAsFixed(0)}'),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // View details action
                                      },
                                      child: const Text('View Details'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Edit action
                                      },
                                      child: const Text('Edit'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Health record action
                                      },
                                      child: const Text('Health Record'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      color: color,
      child: SizedBox(
        width: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}