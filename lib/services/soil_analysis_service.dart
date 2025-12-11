import 'package:farm_up/models/soil_data.dart';
import 'package:farm_up/models/crop_recommendation.dart';
import 'package:farm_up/database/database_helper.dart';
import 'package:farm_up/services/offline_manager.dart';
import 'dart:io';

class SoilAnalysisService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final OfflineManager _offlineManager = OfflineManager();
  
  // In a real app, this would call an API or use ML model
  Future<List<CropRecommendation>> analyzeSoil(SoilData soilData) async {
    try {
      // Check if device is online
      final isOnline = await _isOnline();
      
      if (isOnline) {
        // Online mode - use API
        return await _analyzeSoilOnline(soilData);
      } else {
        // Offline mode - use simplified logic
        return await _analyzeSoilOffline(soilData);
      }
    } catch (e) {
      // Fallback to offline analysis if online fails
      print('Error in soil analysis: $e. Falling back to offline mode.');
      return await _analyzeSoilOffline(soilData);
    }
  }
  
  Future<bool> _isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  Future<List<CropRecommendation>> _analyzeSoilOnline(SoilData soilData) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple logic for demonstration
    List<CropRecommendation> recommendations = [];
    
    if (soilData.pH >= 6.0 && soilData.pH <= 7.5) {
      recommendations.add(CropRecommendation(
        cropName: "Wheat",
        description: "Well-suited for neutral pH soils.",
        expectedYield: 3.5,
        careInstructions: [
          "Plant in October-November",
          "Apply nitrogen fertilizer at tillering stage",
          "Irrigate regularly during grain filling"
        ],
        profitabilityScore: 8.2,
      ));
    }
    
    if (soilData.nitrogen > 20 && soilData.potassium > 15) {
      recommendations.add(CropRecommendation(
        cropName: "Tomatoes",
        description: "Requires nitrogen-rich soil with adequate potassium.",
        expectedYield: 8.0,
        careInstructions: [
          "Transplant after last frost",
          "Prune suckers regularly",
          "Support with cages or stakes"
        ],
        profitabilityScore: 7.8,
      ));
    }
    
    if (soilData.moisture > 25) {
      recommendations.add(CropRecommendation(
        cropName: "Rice",
        description: "Thrives in waterlogged conditions.",
        expectedYield: 4.2,
        careInstructions: [
          "Maintain flooded conditions",
          "Apply basal fertilizer before transplanting",
          "Control weeds manually or chemically"
        ],
        profitabilityScore: 7.5,
      ));
    }
    
    // Default recommendation if none match
    if (recommendations.isEmpty) {
      recommendations.add(CropRecommendation(
        cropName: "Legumes",
        description: "Can improve soil nitrogen naturally.",
        expectedYield: 2.0,
        careInstructions: [
          "Inoculate seeds with rhizobium",
          "Rotate with other crops",
          "Harvest at proper maturity"
        ],
        profitabilityScore: 7.0,
      ));
    }
    
    // Save to local database for offline access
    try {
      await _dbHelper.insertSoilData(soilData);
    } catch (e) {
      print('Error saving soil data locally: $e');
    }
    
    return recommendations;
  }
  
  Future<List<CropRecommendation>> _analyzeSoilOffline(SoilData soilData) async {
    // Simplified offline analysis
    List<CropRecommendation> recommendations = [];
    
    if (soilData.pH >= 6.0 && soilData.pH <= 7.5) {
      recommendations.add(CropRecommendation(
        cropName: "Wheat",
        description: "Well-suited for neutral pH soils.",
        expectedYield: 3.5,
        careInstructions: [
          "Plant in October-November",
          "Apply nitrogen fertilizer at tillering stage",
          "Irrigate regularly during grain filling"
        ],
        profitabilityScore: 8.2,
      ));
    }
    
    if (soilData.nitrogen > 20 && soilData.potassium > 15) {
      recommendations.add(CropRecommendation(
        cropName: "Tomatoes",
        description: "Requires nitrogen-rich soil with adequate potassium.",
        expectedYield: 8.0,
        careInstructions: [
          "Transplant after last frost",
          "Prune suckers regularly",
          "Support with cages or stakes"
        ],
        profitabilityScore: 7.8,
      ));
    }
    
    // Default recommendation if none match
    if (recommendations.isEmpty) {
      recommendations.add(CropRecommendation(
        cropName: "Legumes",
        description: "Can improve soil nitrogen naturally.",
        expectedYield: 2.0,
        careInstructions: [
          "Inoculate seeds with rhizobium",
          "Rotate with other crops",
          "Harvest at proper maturity"
        ],
        profitabilityScore: 7.0,
      ));
    }
    
    return recommendations;
  }
  
  Future<List<String>> getSoilImprovementTips(SoilData soilData) async {
    List<String> tips = [];
    
    if (soilData.pH < 6.0) {
      tips.add("Add lime to raise soil pH");
    } else if (soilData.pH > 7.5) {
      tips.add("Add sulfur or organic matter to lower soil pH");
    }
    
    if (soilData.nitrogen < 20) {
      tips.add("Apply nitrogen-rich fertilizer or compost");
    }
    
    if (soilData.phosphorus < 15) {
      tips.add("Add bone meal or rock phosphate for phosphorus");
    }
    
    if (soilData.potassium < 15) {
      tips.add("Apply potash or wood ash for potassium");
    }
    
    if (soilData.moisture < 20) {
      tips.add("Improve irrigation or add organic matter to retain moisture");
    }
    
    if (tips.isEmpty) {
      tips.add("Your soil is in excellent condition!");
    }
    
    return tips;
  }
  
  // Save soil data locally
  Future<int> saveSoilDataLocally(SoilData soilData) async {
    return await _dbHelper.insertSoilData(soilData);
  }
  
  // Get soil data by user ID
  Future<List<SoilData>> getSoilDataByUserId(int userId) async {
    return await _dbHelper.getSoilDataByUserId(userId);
  }
}