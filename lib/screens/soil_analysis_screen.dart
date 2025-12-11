import 'package:flutter/material.dart';
import 'package:farm_up/widgets/soil_analysis_form.dart';
import 'package:farm_up/widgets/crop_recommendations_list.dart';
import 'package:farm_up/models/crop_recommendation.dart';

class SoilAnalysisScreen extends StatefulWidget {
  const SoilAnalysisScreen({super.key});

  @override
  State<SoilAnalysisScreen> createState() => _SoilAnalysisScreenState();
}

class _SoilAnalysisScreenState extends State<SoilAnalysisScreen> {
  List<CropRecommendation> _recommendations = [];
  bool _showRecommendations = false;

  void _handleResults(List<CropRecommendation> recommendations) {
    setState(() {
      _recommendations = recommendations;
      _showRecommendations = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soil Analysis'),
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
                'Soil Analysis & Crop Recommendation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter your soil test results to get personalized crop recommendations.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SoilAnalysisForm(onResults: _handleResults),
              const SizedBox(height: 20),
              if (_showRecommendations) ...[
                const Text(
                  'Recommended Crops',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CropRecommendationsList(recommendations: _recommendations),
                const SizedBox(height: 20),
                const Text(
                  'Soil Improvement Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: isDarkMode ? Colors.grey[800] : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Based on your soil analysis, here are some tips to improve your soil health:',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '• Add organic compost to increase nutrient content',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.black,
                          ),
                        ),
                        Text(
                          '• Consider crop rotation to maintain soil fertility',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.black,
                          ),
                        ),
                        Text(
                          '• Test soil pH annually and adjust as needed',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.black,
                          ),
                        ),
                        Text(
                          '• Use cover crops during off-seasons to prevent erosion',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[300] : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}