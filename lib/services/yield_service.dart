import 'package:farm_up/models/yield_data.dart';

class YieldService {
  List<YieldData> _yieldDataList = [];
  List<FieldProductivity> _fieldProductivityList = [];
  
  // Initialize with sample data
  void initializeSampleData() {
    // Sample yield data
    final wheatYield2024 = YieldData(
      id: 1,
      cropName: 'Wheat',
      fieldName: 'North Field',
      areaHectares: 5.0,
      plantingDate: DateTime(2024, 11, 15),
      harvestDate: DateTime(2025, 4, 20),
      yieldInQuintals: 180.0,
      yieldPerHectare: 36.0,
      season: 'Winter 2024-25',
      notes: 'Good yield due to adequate rainfall',
    );
    
    final wheatYield2023 = YieldData(
      id: 2,
      cropName: 'Wheat',
      fieldName: 'North Field',
      areaHectares: 5.0,
      plantingDate: DateTime(2023, 11, 10),
      harvestDate: DateTime(2024, 4, 15),
      yieldInQuintals: 165.0,
      yieldPerHectare: 33.0,
      season: 'Winter 2023-24',
      notes: 'Slightly lower due to delayed planting',
    );
    
    final riceYield2024 = YieldData(
      id: 3,
      cropName: 'Rice',
      fieldName: 'South Field',
      areaHectares: 3.5,
      plantingDate: DateTime(2024, 6, 1),
      harvestDate: DateTime(2024, 10, 15),
      yieldInQuintals: 140.0,
      yieldPerHectare: 40.0,
      season: 'Summer 2024',
      notes: 'Excellent yield with proper water management',
    );
    
    // Sample field productivity data
    final northFieldProductivity = FieldProductivity(
      id: 1,
      fieldName: 'North Field',
      areaHectares: 5.0,
      yieldHistory: [wheatYield2024, wheatYield2023],
      averageYieldPerHectare: 34.5,
      productivityTrend: 'Increasing',
    );
    
    final southFieldProductivity = FieldProductivity(
      id: 2,
      fieldName: 'South Field',
      areaHectares: 3.5,
      yieldHistory: [riceYield2024],
      averageYieldPerHectare: 40.0,
      productivityTrend: 'Stable',
    );
    
    _yieldDataList = [wheatYield2024, wheatYield2023, riceYield2024];
    _fieldProductivityList = [northFieldProductivity, southFieldProductivity];
  }
  
  // Add new yield data
  void addYieldData(YieldData yieldData) {
    _yieldDataList.add(yieldData);
    _updateFieldProductivity(yieldData);
  }
  
  // Get all yield data
  List<YieldData> getAllYieldData() {
    return List.from(_yieldDataList);
  }
  
  // Get yield data by crop
  List<YieldData> getYieldDataByCrop(String cropName) {
    return _yieldDataList
        .where((yield) => yield.cropName.toLowerCase() == cropName.toLowerCase())
        .toList();
  }
  
  // Get yield data by field
  List<YieldData> getYieldDataByField(String fieldName) {
    return _yieldDataList
        .where((yield) => yield.fieldName.toLowerCase() == fieldName.toLowerCase())
        .toList();
  }
  
  // Get yield data by season
  List<YieldData> getYieldDataBySeason(String season) {
    return _yieldDataList
        .where((yield) => yield.season.toLowerCase() == season.toLowerCase())
        .toList();
  }
  
  // Get all field productivity data
  List<FieldProductivity> getAllFieldProductivity() {
    return List.from(_fieldProductivityList);
  }
  
  // Get field productivity by field name
  FieldProductivity? getFieldProductivityByName(String fieldName) {
    try {
      return _fieldProductivityList.firstWhere(
        (field) => field.fieldName.toLowerCase() == fieldName.toLowerCase()
      );
    } catch (e) {
      return null;
    }
  }
  
  // Get yield trends
  Map<String, dynamic> getYieldTrends() {
    final trends = <String, dynamic>{};
    
    // Calculate average yields by crop
    final cropYields = <String, List<double>>{};
    for (final yield in _yieldDataList) {
      if (cropYields.containsKey(yield.cropName)) {
        cropYields[yield.cropName]!.add(yield.yieldPerHectare);
      } else {
        cropYields[yield.cropName] = [yield.yieldPerHectare];
      }
    }
    
    final avgYields = <String, double>{};
    cropYields.forEach((crop, yields) {
      final sum = yields.reduce((a, b) => a + b);
      avgYields[crop] = sum / yields.length;
    });
    
    trends['averageYieldsByCrop'] = avgYields;
    trends['totalYieldRecords'] = _yieldDataList.length;
    
    return trends;
  }
  
  // Get productivity insights
  List<String> getProductivityInsights() {
    final insights = <String>[];
    
    for (final field in _fieldProductivityList) {
      if (field.productivityTrend == 'Increasing') {
        insights.add('${field.fieldName} shows increasing productivity');
      } else if (field.productivityTrend == 'Decreasing') {
        insights.add('${field.fieldName} shows declining productivity - investigation needed');
      }
      
      if (field.averageYieldPerHectare > 35.0) {
        insights.add('${field.fieldName} is highly productive (>${field.averageYieldPerHectare} q/ha)');
      }
    }
    
    if (insights.isEmpty) {
      insights.add('All fields are performing steadily');
    }
    
    return insights;
  }
  
  // Predict next harvest
  Map<String, dynamic> predictNextHarvest(String cropName, String fieldName) {
    final prediction = <String, dynamic>{};
    
    // Find recent yield data for the crop and field
    final relevantYields = _yieldDataList
        .where((yield) => 
            yield.cropName.toLowerCase() == cropName.toLowerCase() &&
            yield.fieldName.toLowerCase() == fieldName.toLowerCase())
        .toList()
      ..sort((a, b) => b.harvestDate.compareTo(a.harvestDate));
    
    if (relevantYields.isNotEmpty) {
      final latestYield = relevantYields.first;
      
      // Simple prediction based on previous yield
      final predictedYield = latestYield.yieldPerHectare * 1.05; // 5% increase assumption
      
      prediction['predictedYieldPerHectare'] = predictedYield;
      prediction['confidence'] = 'Medium';
      prediction['factors'] = 'Based on historical yield trends and seasonal improvements';
    } else {
      prediction['predictedYieldPerHectare'] = 0.0;
      prediction['confidence'] = 'Low';
      prediction['factors'] = 'No historical data available for this crop and field combination';
    }
    
    return prediction;
  }
  
  // Private method to update field productivity when new yield data is added
  void _updateFieldProductivity(YieldData newYield) {
    // Check if field already exists in productivity list
    final existingFieldIndex = _fieldProductivityList.indexWhere(
      (field) => field.fieldName == newYield.fieldName
    );
    
    if (existingFieldIndex != -1) {
      // Update existing field
      final existingField = _fieldProductivityList[existingFieldIndex];
      final updatedYieldHistory = List<YieldData>.from(existingField.yieldHistory)
        ..add(newYield);
      
      // Recalculate average yield
      double totalYield = 0;
      for (final yield in updatedYieldHistory) {
        totalYield += yield.yieldPerHectare;
      }
      final newAverage = totalYield / updatedYieldHistory.length;
      
      // Determine trend (simplified)
      String trend = 'Stable';
      if (updatedYieldHistory.length > 1) {
        final previousYield = updatedYieldHistory[updatedYieldHistory.length - 2].yieldPerHectare;
        if (newYield.yieldPerHectare > previousYield * 1.05) {
          trend = 'Increasing';
        } else if (newYield.yieldPerHectare < previousYield * 0.95) {
          trend = 'Decreasing';
        }
      }
      
      _fieldProductivityList[existingFieldIndex] = FieldProductivity(
        id: existingField.id,
        fieldName: existingField.fieldName,
        areaHectares: existingField.areaHectares,
        yieldHistory: updatedYieldHistory,
        averageYieldPerHectare: newAverage,
        productivityTrend: trend,
      );
    } else {
      // Add new field
      _fieldProductivityList.add(FieldProductivity(
        fieldName: newYield.fieldName,
        areaHectares: newYield.areaHectares,
        yieldHistory: [newYield],
        averageYieldPerHectare: newYield.yieldPerHectare,
        productivityTrend: 'New',
      ));
    }
  }
}