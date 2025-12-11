import 'package:flutter/material.dart';
import 'package:farm_up/services/yield_service.dart';
import 'package:farm_up/models/yield_data.dart';

class YieldTrackingScreen extends StatefulWidget {
  const YieldTrackingScreen({super.key});

  @override
  State<YieldTrackingScreen> createState() => _YieldTrackingScreenState();
}

class _YieldTrackingScreenState extends State<YieldTrackingScreen> {
  final YieldService _yieldService = YieldService();
  List<YieldData> _yieldDataList = [];
  List<FieldProductivity> _fieldProductivityList = [];
  List<String> _productivityInsights = [];
  Map<String, dynamic> _yieldTrends = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _yieldService.initializeSampleData();
    _loadYieldData();
  }

  void _loadYieldData() {
    setState(() {
      _isLoading = true;
    });

    try {
      final yieldData = _yieldService.getAllYieldData();
      final fieldProductivity = _yieldService.getAllFieldProductivity();
      final insights = _yieldService.getProductivityInsights();
      final trends = _yieldService.getYieldTrends();
      
      setState(() {
        _yieldDataList = yieldData;
        _fieldProductivityList = fieldProductivity;
        _productivityInsights = insights;
        _yieldTrends = trends;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load yield data: $e')),
        );
      }
    }
  }

  void _addYieldData() {
    // In a real app, this would open a form to add new yield data
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adding new yield data...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yield Tracking'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Fields'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Overview Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yield Analytics Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Key Metrics
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildMetricCard(
                              'Total Records',
                              '${_yieldDataList.length}',
                              Icons.bar_chart,
                              Colors.green,
                            ),
                            const SizedBox(width: 10),
                            _buildMetricCard(
                              'Fields Tracked',
                              '${_fieldProductivityList.length}',
                              Icons.map,
                              Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            _buildMetricCard(
                              'Avg. Yield',
                              '${(_yieldTrends['averageYieldsByCrop'] as Map?)?.values.fold(0.0, (prev, elem) => prev + elem as double).toDouble() ~/ ((_yieldTrends['averageYieldsByCrop'] as Map?)?.length ?? 1)} q/ha',
                              Icons.grain,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Productivity Insights
                      const Text(
                        'Productivity Insights',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_productivityInsights.isEmpty)
                        const Center(
                          child: Text('No insights available'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _productivityInsights.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Icon(
                                  _productivityInsights[index].contains('increasing') 
                                      ? Icons.trending_up 
                                      : _productivityInsights[index].contains('declining') 
                                          ? Icons.trending_down 
                                          : Icons.info,
                                  color: _productivityInsights[index].contains('increasing') 
                                      ? Colors.green 
                                      : _productivityInsights[index].contains('declining') 
                                          ? Colors.red 
                                          : Colors.blue,
                                ),
                                title: Text(_productivityInsights[index]),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      // Average Yields by Crop
                      const Text(
                        'Average Yields by Crop',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if ((_yieldTrends['averageYieldsByCrop'] as Map?)?.isEmpty ?? true)
                        const Center(
                          child: Text('No yield data available'),
                        )
                      else
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: (_yieldTrends['averageYieldsByCrop'] as Map?)
                                  ?.entries
                                  .map((entry) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(entry.key),
                                            Text('${entry.value.toStringAsFixed(1)} q/ha'),
                                          ],
                                        ),
                                      ))
                                  .toList() ??
                                  [],
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Fields Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Field Productivity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_fieldProductivityList.isEmpty)
                      const Center(
                        child: Text('No field data available'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _fieldProductivityList.length,
                        itemBuilder: (context, index) {
                          final field = _fieldProductivityList[index];
                          return Card(
                            child: ExpansionTile(
                              title: Text(field.fieldName),
                              subtitle: Text('${field.areaHectares} hectares'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Avg. Yield:'),
                                          Text(
                                            '${field.averageYieldPerHectare.toStringAsFixed(1)} q/ha',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Trend:'),
                                          Text(
                                            field.productivityTrend,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: field.productivityTrend == 'Increasing' 
                                                  ? Colors.green 
                                                  : field.productivityTrend == 'Decreasing' 
                                                      ? Colors.red 
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Yield History:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      ...field.yieldHistory.map((yield) => Padding(
                                            padding: const EdgeInsets.only(bottom: 5.0),
                                            child: Row(
                                              children: [
                                                Text('${yield.cropName} (${yield.season})'),
                                                const Spacer(),
                                                Text('${yield.yieldPerHectare.toStringAsFixed(1)} q/ha'),
                                              ],
                                            ),
                                          )),
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
            
            // History Tab
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yield History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_yieldDataList.isEmpty)
                      const Center(
                        child: Text('No yield history available'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _yieldDataList.length,
                        itemBuilder: (context, index) {
                          final yield = _yieldDataList[index];
                          return Card(
                            child: ListTile(
                              title: Text('${yield.cropName} - ${yield.fieldName}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(yield.season),
                                  Text(
                                    'Harvested: ${yield.harvestDate.toString().split(' ').first}',
                                  ),
                                  Text(
                                    'Yield: ${yield.yieldPerHectare.toStringAsFixed(1)} q/ha',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              trailing: Text('${yield.daysToHarvest} days'),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addYieldData,
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: color,
      child: SizedBox(
        width: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}